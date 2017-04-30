


#include "GFHOG.h"
//#include "SuperLU_5.2.1/SRC/slu_ddefs.h"
#include <map>
#include "HogDetect.h"
#include <cstring>



#include "armadillo"



using namespace arma;

//using namespace superlu;



/////////////////////////////////////////////////////////
//void create_CompCol_Matrix(SuperMatrix *A,int m,int n,int nnz, double *nzval,int *rowind,int *colptr,Stype_t stype, Dtype_t dtype, Mtype_t mtype){
//    NCformat *Astore;
//    A->Stype = stype;
//    A->Dtype = dtype;
//    A->Mtype = mtype;
//    A->nrow = m;
//    A->ncol = n;
//    char *buf=(char *) std::malloc(sizeof(NCformat)+sizeof(double));
//    ((unsigned long *) buf)[0] = sizeof(NCformat);
//    buf=buf+sizeof(double);
//    A->Store = (void *) (buf);
//    if ( !(A->Store) ) strerror(4);
//    Astore = (NCformat *)A->Store;
//    Astore->nnz = nnz;
//    Astore->nzval = nzval;
//    Astore->rowind = rowind;
//    Astore->colptr = colptr;
//    
//}
//void create_Dense_Matrix(SuperMatrix *X, int m, int n, double *x, int ldx,Stype_t stype, Dtype_t dtype, Mtype_t mtype){
//    DNformat    *Xstore;
//    X->Stype = stype;
//    X->Dtype = dtype;
//    X->Mtype = mtype;
//    X->nrow = m;
//    X->ncol = n;
//    char *buf=(char *) std::malloc(sizeof(NCformat)+sizeof(double));
//    ((unsigned long *) buf)[0] = sizeof(NCformat);
//    buf=buf+sizeof(double);
//    X->Store = (void *) buf;
//    Xstore = (DNformat *) X->Store;
//    Xstore->lda = ldx;
//    Xstore->nzval = (double *) x;
//    
//}
//
//
//
//
//
//int *intMalloc(int n) {
//    int *buf;
//    buf = (int *) superlu_malloc((size_t) n * sizeof(int));
//    if ( !buf ) {
//        strerror(1);
//    }
//    return (buf);
//}
//
//double *doubleMalloc(int n)
//{
//    double *buf;
//    buf = (double *) superlu_malloc((size_t)n * sizeof(double));
//    if ( !buf ) {
//        strerror(1);
//    }
//    return (buf);
//}
//




GFHOG::GFHOG(void):_gradient(NULL)
{
}


GFHOG::~GFHOG(void)
{
	if (_gradient){
		cvReleaseImage(&_gradient);
		_gradient = NULL;
	}
}
void GFHOG::Compute(IplImage* src,GFHOGType t, IplImage* mask){
	assert(src->depth == 8);
	switch (t){
	case Image:
		ComputeImage(src,mask);
		break;
	case Sketch:
		ComputeSketch(src,mask);
		break;
	}
}

void GFHOG::ComputeImage(IplImage* src,IplImage* mask){
	IplImage* runImg = cvCloneImage(src);
	if (src->nChannels > 1){
		IplImage* gimg=cvCreateImage(cvGetSize(runImg),src->depth,1);
		cvCvtColor(runImg,gimg,CV_BGR2GRAY);
		cvReleaseImage(&runImg);
		runImg = gimg;
	}
	IplImage* edge=cvCreateImage(cvGetSize(runImg),runImg->depth,1);
	for (int s=19; s>=1; s-=2) {
		cvSmooth(runImg,edge,CV_GAUSSIAN,s);
		cvCanny(edge,edge,100,200);
		CvScalar sc=cvSum(edge);
		float area=sc.val[0]/(float)(255*runImg->width*runImg->height);
		if (area>0.02)
			break;
	}
	cvNot(edge,edge);
	ComputeGradient(edge,mask);
}

void GFHOG::ComputeSketch(IplImage* src,IplImage* mask){
	IplImage* runImg = cvCloneImage(src);
	if (src->nChannels > 1){
		IplImage* gimg=cvCreateImage(cvGetSize(runImg),8,1);
		cvCvtColor(runImg,gimg,CV_BGR2GRAY);
		cvReleaseImage(&runImg);
		runImg = gimg;
	} 
	ComputeGradient(runImg,mask);
}

void GFHOG::ComputeGradient(IplImage* sk8bit,IplImage* mask){
	if (!mask){
		mask = cvCreateImage(cvGetSize(sk8bit),8,1);
		cvZero(mask);
		cvNot(mask,mask);
	}
	IplImage* gradient=cvCreateImage(cvGetSize(sk8bit),32,1);
	cvConvertScale(sk8bit,gradient,1.0/255.0,0);
	gradientField(gradient,mask);

	IplImage* g = cvCreateImage(cvGetSize(gradient),32,1);
	double mi,ma;
	cvMinMaxLoc(g,&mi,&ma);
	CvScalar s;
	s.val[0] = mi;
	cvSubS(g,s,g);
	cvScale(g,g,1.0 / (ma-mi));

	cvNot(sk8bit,sk8bit);
	_gradient = gradient;
	histogramOfGradients(sk8bit,gradient);
}

IplImage* GFHOG::ResizeToFaster(IplImage* img,int maxdim)
{
	CvSize s;
	if (img->width > maxdim){
		float r = (float)maxdim / img->width ;
		s.width = maxdim;
		s.height = (float)(img->height) * r;
	}else{
		float r = (float)maxdim / img->height ;
		s.height = maxdim;
		s.width = (float)(img->width) * r;
	}
	IplImage* resize = cvCreateImage(s,img->depth,img->nChannels);
	cvResize(img,resize);
	return  resize;
}

void GFHOG::histogramOfGradients(IplImage* edge,IplImage* gradient)
{
	std::vector<int> scales;
	SETUP_SCALES

//	cvNot(edge,edge);

#ifdef NOHOGZONE
	HogDetect* H=new HogDetect(gradient,edge);
#else
	HogDetect* H=new HogDetect(gradient);
#endif

	HOGPARAMS params;
	params.hogchannels=9;
	params.superwinsize=3;
	int D=params.superwinsize * params.superwinsize* params.hogchannels;
	float* histo=new float[D];
	for (std::vector<int>::iterator t=scales.begin(); t!=scales.end(); t++) {
		params.winsize=*t;
		memset(histo,0,sizeof(float)*D);
		for (int y=0; y<edge->height; y++) {	
			for (int x=0; x<edge->width; x++) {	
				if (edge->imageData[x+y*edge->widthStep] ) {
					
					H->GetHOG(x,y,histo,&params);
				
					if (histo[0]!=-1) {
						std::vector<double> descriptor;
						for (int i = 0 ; i < D ; i++)
							descriptor.push_back(histo[i]);
						push_back(descriptor);
					}
					
				}				
			}
		}
	}

	delete [] histo;
	delete H;
}


void GFHOG::gradientField(IplImage* inpmask32,IplImage* filtermask32)
{

	int ww=inpmask32->width/POISSON_SPEEDUP_DEGRADE;
	int hh=inpmask32->height/POISSON_SPEEDUP_DEGRADE;

	IplImage* mask32=cvCreateImage(cvSize(ww,hh),32,1);
	cvResize(inpmask32,mask32,CV_INTER_LINEAR);

	// gradient interpolation
	IplImage* mask=cvCreateImage(cvGetSize(mask32),8,1);
	cvConvertScale(mask32,mask,255.0,0);

	IplImage* dx=cvCreateImage(cvGetSize(mask),32,1);
	IplImage* dy=cvCreateImage(cvGetSize(mask),32,1);

	cvSobel(mask32,dx,1,0,3);
	cvSobel(mask32,dy,0,1,3);



	cvMul(filtermask32,dx,dx);
	cvMul(filtermask32,dy,dy);

	//cvNot(mask,mask);
	for (int j=0; j<mask->height; j++) {		
		mask->imageData[j*mask->width]=0;
		mask->imageData[j*mask->width + (mask->width-1)]=0;
	}
	memset(mask->imageData,0,mask->width);
	memset(mask->imageData+(mask->height-1)*mask->width,0,mask->width);

	cvErode(mask,mask);


#ifdef SKIP_GRADIENT_FIELD_INTERPOLATION
	IplImage* result_dx=cvCloneImage(dx);
	IplImage* result_dy=cvCloneImage(dy);
#else
	IplImage* result_dx=poissoncompute(dx,mask);
	IplImage* result_dy=poissoncompute(dy,mask);
#endif


	IplImage* mag=cvCreateImage(cvGetSize(result_dx),32,1);
	IplImage* ang=cvCreateImage(cvGetSize(result_dx),32,1);

	cvCartToPolar(result_dx,result_dy,ang,mag);
#ifdef DO_COSINE
	cvReleaseImage(&ang);
	ang=mag;
	for (int y=0; y<ang->height; y++) {
		for (int x=0; x<ang->width; x++) {
			((float*)ang->imageData)[x+y*ang->width]=cos(((float*)ang->imageData)[x+y*ang->width]);
				
		}
	}
	cvConvertScale(ang,ang,1.0/2.0,0.5);
#else
	cvConvertScale(mag,ang,1.0/(2.0*PI),0);
	cvReleaseImage(&mag);
#endif

	//cvCopy(ang,mask32);
	cvReleaseImage(&mask);
	cvReleaseImage(&dx);
	cvReleaseImage(&dy);

	cvResize(ang,inpmask32,CV_INTER_LINEAR);
	cvReleaseImage(&ang);

}

IplImage* GFHOG::poissoncompute(IplImage* src, IplImage* mask){
   

    std::map<unsigned int,unsigned int>	masked;
	int N = 0;
    for (int y = 1; y < src->height-1; y++) {
		for (int x = 1; x < src->width-1; x++) {
			unsigned int id = y*src->width+x;
			if (mask->imageData[id]) {  //Masked pixel
				masked[id] = N;
				N++;
			}
		}
	}

    
    //sp_mat A, L, U;
    //mat B;
    
	//SuperMatrix    A, L, U;
	//SuperMatrix    B;
	//NCformat       *Ustore;
    double         *a,*rhs; //,*u;
	int            *asub, *xa;
	int            *perm_r;  //row permutations from partial pivoting
	int            *perm_c;  //column permutation vector
	int            info, nrhs,row_inc;
	int            m, n, nnz,index;
	//superlu_options_t options;
	//SuperLUStat_t stat;
	//set_default_options(&options);

  

    
	m = n =  N;
	nnz = N * 5;
    
    uvec rowindA(nnz);
    
    uvec colptrA(n+1);
    
    vec valuesA(nnz);
    fprintf(stderr, "in");

    

	//if ( !(a = (double *)malloc(nnz * sizeof(double))) ) strerror(1);
	//if ( !(asub = (int *)malloc(nnz * sizeof(int))) ) strerror(1);
	//if ( !(xa = (int *)malloc((n+1) * sizeof(int))) ) strerror(1);


	nrhs = 1;
	index = 0;
	if ( !(rhs = (double *) malloc(m * nrhs * sizeof(double))) ) strerror(1);;
	row_inc = 0;
    
    fprintf(stderr, "in");
	for (int y = 1; y < src->height-1; y++) {
		for (int x = 1; x < src->width-1; x++) {
			if (mask->imageData[x+y*src->width]) {  //Variable
                
                unsigned int id = x+y*src->width;
				
                if (row_inc >= n+1) printf("fcked");
                
                colptrA(row_inc) = index;

				 //Right hand side is initialized to zero
				CvScalar bb=cvScalarAll(0);

				if (mask->imageData[(x)+(y-1)*src->width]) {
                    if (index >= nnz) {
                        printf("a111111");
                    }
                    
                    valuesA(index) = 1.0;
					rowindA(index) = masked[id-src->width];
					index++;
				} else {
					// Known pixel, update right hand side
					bb=sub(bb,cvGet2D(src,y-1,x));
				}


				if (mask->imageData[(x-1)+(y)*src->width]) {
                    if (index >= nnz) {
                        printf("a111111");
                    }
                    
                    valuesA(index) = 1.0;
					rowindA(index) = masked[id-1];
					index++;
				} else {
					bb=sub(bb,cvGet2D(src,y,x-1));
				}
                
                if (index >= nnz) {
                    printf("a111111");
                }
				valuesA(index) = -4.0;
				rowindA(index) = masked[id];
				index++;

				if (mask->imageData[(x+1)+(y)*src->width]) {
                    if (index >= nnz) {
                        printf("a111111");
                    }
                    
                    valuesA(index) = 1.0;
					rowindA(index) = masked[id+1];
					index++;
				} else {
					bb=sub(bb,cvGet2D(src,y,x+1));
				}

				if (mask->imageData[(x)+(y+1)*src->width]) {
                    if (index >= nnz) {
                        printf("a111111");
                    }
                    valuesA(index) = 1.0;
					rowindA(index) = masked[id+src->width];
					index++;
				} else {
					bb=sub(bb,cvGet2D(src,y+1,x));
				}

				unsigned int i = masked[id];
				 //Spread the right hand side so we can solve using TAUCS for
				 //3 channels at once.
				for (int chan=0; chan<src->nChannels; chan++) {
					
                    if (i + N*chan > (m*nrhs)) printf("humped");
                    rhs[i+N*chan] = bb.val[chan];
				}
				row_inc++;
			}
		}
	}
    
    printf("out");
    fflush(stdout);
	assert(row_inc == N);
	colptrA(n) = index;

    printf("ascas");

    //uvec rowindA = uvec(*asub, 1);
    
    printf("1");

    //uvec colptrA = uvec(*xa, n + 1);
    printf("2");

    //vec valuesA = vec(*a, nnz);
	 //Create matrix A in the format expected by SuperLU.
	//create_CompCol_Matrix(&A, m, n, nnz, a, asub, xa, SLU_NC, SLU_D, SLU_GE);
	 //Create right-hand side matrix B.
	//create_Dense_Matrix(&B, m, nrhs, rhs, m, SLU_DN, SLU_D, SLU_GE);
	 //Set the default input options.
    printf("ascas");
    rowindA.transform( [](double val) { return (val > 8640 ? 0.0 : val); } );
    valuesA.transform( [](double val) { return (std::isnan(val) ? 0.0 : val); } );
    sp_mat A = sp_mat(rowindA, colptrA, valuesA, m, n);
    //A.transform( [](double val) { return (std::isnan(val) ? 0.0 : val); } );
    //mat A_ = mat(A);
    //cout << A_.size() << endl;
    mat B = mat(rhs, m, nrhs);
	//set_default_options(&options);
	//options.ColPerm = NATURAL;
	//options.Trans = TRANS;
	//options.ColPerm = COLAMD;
	if ( !(perm_r = (int *)malloc(m * sizeof(int))) ) strerror(1);
	if ( !(perm_c = (int *)malloc(n * sizeof(int))) ) strerror(1);

	 //Initialize the statistics variables.
	//StatInit(&stat);
	 //Solve the linear system.
    //dgssv(&options, &A, perm_c, perm_r, &L, &U, &B, &stat, &info);
    
    printf("aaaaaaa");
    mat X = spsolve(A, B, "lapack");
    
    vec u = vectorise(X);
    //Ustore = (NCformat *)B.Store;
	//u = (double*) Ustore->nzval;
	IplImage* result=cvCreateImage(cvGetSize(src),32,src->nChannels);
	cvCopy(src,result);
	for (int y = 1; y < src->height; y++) {
		for (int x = 1; x < src->width; x++) {
			if (mask->imageData[(x)+(y)*src->width]) {
				unsigned int id = y*src->width+x;
				unsigned int ii = masked[id];
				CvScalar p;
				for (int chan=0; chan<src->nChannels; chan++) {
					p.val[chan]=u(ii+N*chan);
				}
				cvSet2D(result,y,x,p);
			}
		}
	}
	// Clean Up Solver
	//superlu_free (rhs);
	//superlu_free(perm_r);
	//superlu_free (perm_c);
	//Destroy_CompCol_Matrix(&A);
	//Destroy_SuperMatrix_Store(&B);
	//Destroy_SuperNode_Matrix(&L);
	//Destroy_CompCol_Matrix(&U);
	return result;
}


inline CvScalar GFHOG::sub(CvScalar a, CvScalar b) {

	a.val[0]-=b.val[0];
	a.val[1]-=b.val[1];
	a.val[2]-=b.val[2];
	a.val[3]-=b.val[3];

	return a;
}
