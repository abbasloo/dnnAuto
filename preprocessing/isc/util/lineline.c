#include <math.h>
#include "mex.h"

typedef struct {
   double x,y,z;
} XYZ;

#define EPS 1e-20
#define FALSE 0
#define TRUE  1
double ABS(double x)
{ if (x<0) 
      return(-x);
  else return(x);
}
double po2(double x)
{     return(x*x);  
}
/*
   Calculate the line segment PaPb that is the shortest route between
   two lines P1P2 and P3P4. Calculate also the values of mua and mub where
      Pa = P1 + mua (P2 - P1)
      Pb = P3 + mub (P4 - P3)
   Return FALSE if no solution exists.
*/
int LineLineIntersect(
   XYZ p1,XYZ p2,XYZ p3,XYZ p4,XYZ *pa,XYZ *pb,
   double *mua, double *mub)
{
   XYZ p13,p43,p21;
   double d1343,d4321,d1321,d4343,d2121;
   double numer,denom;

   p13.x = p1.x - p3.x;
   p13.y = p1.y - p3.y;
   p13.z = p1.z - p3.z;
   p43.x = p4.x - p3.x;
   p43.y = p4.y - p3.y;
   p43.z = p4.z - p3.z;
   if (ABS(p43.x) < EPS && ABS(p43.y) < EPS && ABS(p43.z) < EPS)
      return(FALSE);
   p21.x = p2.x - p1.x;
   p21.y = p2.y - p1.y;
   p21.z = p2.z - p1.z;
   if (ABS(p21.x) < EPS && ABS(p21.y) < EPS && ABS(p21.z) < EPS)
      return(FALSE);

   d1343 = p13.x * p43.x + p13.y * p43.y + p13.z * p43.z;
   d4321 = p43.x * p21.x + p43.y * p21.y + p43.z * p21.z;
   d1321 = p13.x * p21.x + p13.y * p21.y + p13.z * p21.z;
   d4343 = p43.x * p43.x + p43.y * p43.y + p43.z * p43.z;
   d2121 = p21.x * p21.x + p21.y * p21.y + p21.z * p21.z;

   denom = d2121 * d4343 - d4321 * d4321;
   if (ABS(denom) < EPS)
      return(FALSE);
   numer = d1343 * d4321 - d1321 * d4343;

   *mua = numer / denom;
   *mub = (d1343 + d4321 * (*mua)) / d4343;

   pa->x = p1.x + *mua * p21.x;
   pa->y = p1.y + *mua * p21.y;
   pa->z = p1.z + *mua * p21.z;
   pb->x = p3.x + *mub * p43.x;
   pb->y = p3.y + *mub * p43.y;
   pb->z = p3.z + *mub * p43.z;

   return(TRUE);
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{
/*caled as: [pa, pb, mua, mub] = LineLineIntersect(p1,p2,p3,p4)*/
    XYZ  *ps,pa,pb;
    
   double *yp0,*yp1,*yp2,*yp3,*pt;
   double mua, mub;
   int i;
   
   ps = malloc(4*sizeof(XYZ));
   /*//m//exPrintf("here");*/
   for ( i= 0;i<4;i++)
   {
   pt = mxGetPr(prhs[i]);
   ps[i].x = pt[0];
   ps[i].y = pt[1];
   ps[i].z = pt[2];
   }
  /*// mexPrintf("here");*/
   LineLineIntersect(ps[0], ps[1], ps[2], ps[3],&pa,&pb,&mua,&mub);
   free(ps);
/*///mexPrintf("here");*/
    /* Create a mat;rix for the return argument */ 
   /*
    plhs[0] = mxCreateDoubleMatrix(1, 3, mxREAL); 
    plhs[1] = mxCreateDoubleMatrix(1, 3, mxREAL); 
    */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL); 
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL); 
      /*
   // mexPrintf("here");
    yp0 = mxGetPr(plhs[0]);
    yp0[0] = pa.x;
    yp0[1] = pa.y;
    yp0[2] = pa.z;
    
    
    yp1 = mxGetPr(plhs[1]);
    yp1[0] = pb.x;
    yp1[1] = pb.y;
    yp1[2] = pb.z;
*/
    
    yp2 = mxGetPr(plhs[0]);
    yp2[0] = po2(pa.x - pb.x) + po2(pa.y-pb.y) + po2(pa.z - pb.z);
    
    yp3 = mxGetPr(plhs[1]);
    yp3[0] = mub;
        
}



