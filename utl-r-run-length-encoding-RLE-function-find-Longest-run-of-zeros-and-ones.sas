    %let pgm=utl-r-run-length-encoding-RLE-function-find-Longest-run-of-zeros-and-ones;

    Run length encoding RLE function find Longest run of zeros and ones

    github
    http://tinyurl.com/5b9zusmn
    https://github.com/rogerjdeangelis/utl-r-run-length-encoding-RLE-function-find-Longest-run-of-zeros-and-ones

    /*               _     _
     _ __  _ __ ___ | |__ | | ___ _ __ ___
    | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
    | |_) | | | (_) | |_) | |  __/ | | | | |
    | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
    |_|
    */

    /**************************************************************************************************************************/
    /*                                    |                                            |                                      */
    /*        INPUT                       |                PROCESS                     |             OUTPUT                   */
    /*                                    |                                            |                                      */
    /* SD1.HAVE total obs=10              |    have<-read_sas("d:/sd1/have.sas7bdat"); |    WANT_R_LONG_NAMES total obs=2     */
    /*                                    |    want<-tapply(                           |                                      */
    /* Obs    FLP                         |         rle(have$FLP)$lengths              |   Obs    WANT    LVLS                */
    /*                                    |         ,rle(have$FLP)$values,FUN=max      |                                      */
    /*   1     0                          |         );                                 |    1      3       0                  */
    /*   2     1                          |                                            |    2      4       1                  */
    /*   3     0                          |                                            |                                      */
    /*   4     1                          |                                            |                                      */
    /*   5     1                          |                                            |                                      */
    /*   6     1                          |                                            |                                      */
    /*   7     1   max length of 1s is 4  |                                            |                                      */
    /*   8     0                          |                                            |                                      */
    /*   9     0                          |                                            |                                      */
    /*  10     0   max length of 0s is 3  |                                            |                                      */
    /*                                    |                                            |                                      */
    /**************************************************************************************************************************/

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

    options validvarname=upcase;
    libname sd1 "d:/sd1";
    data sd1.have;
       do _i_=1 to 10;
         flp=(uniform(5731)>.5);
         output;
       end;
       drop _i_;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*     INPUT                                                                                                              */
    /*                                                                                                                        */
    /*   Obs    FLP                                                                                                           */
    /*                                                                                                                        */
    /*     1     0                                                                                                            */
    /*     2     1                                                                                                            */
    /*     3     0                                                                                                            */
    /*     4     1                                                                                                            */
    /*     5     1                                                                                                            */
    /*     6     1                                                                                                            */
    /*     7     1                                                                                                            */
    /*     8     0                                                                                                            */
    /*     9     0                                                                                                            */
    /*    10     0                                                                                                            */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

     /*
     _ __  _ __ ___   ___ ___  ___ ___
    | `_ \| `__/ _ \ / __/ _ \/ __/ __|
    | |_) | | | (_) | (_|  __/\__ \__ \
    | .__/|_|  \___/ \___\___||___/___/
    |_|
    */

    proc datasets lib=sd1 nolist mt=data mt=view nodetails;delete want; run;quit;

    %utl_rbegin;
    parmcards4;
    library(haven);
    library(SASxport);
    have<-read_sas("d:/sd1/have.sas7bdat");
    want<-tapply(
         rle(have$FLP)$lengths
         ,rle(have$FLP)$values,FUN=max
          );
    want<-as.data.frame(want);
    want$lvls<-c("0","1");
    want;
    for (i in 1:ncol(want)) {
          label(want[,i])<-colnames(want)[i];
          print(label(want[,i])); };
    write.xport(want,file="d:/xpt/want.xpt");
    ;;;;
    %utl_rend;

    proc datasets lib=work mt=data mt=view nolist nodetails; delete want want_r_long_names; run;quit;

    /*--- handles long variable names by using the label to rename the variables  ----*/

    libname xpt xport "d:/xpt/want.xpt";
    proc contents data=xpt._all_;
    run;quit;

    data want_r_long_names;
      %utl_rens(xpt.want) ;
      set want;
    run;quit;
    libname xpt clear;

    proc print;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* WANT_R_LONG_NAMES total obs=2                                                                                          */
    /*                                                                                                                        */
    /* Obs    WANT    LVLS                                                                                                    */
    /*                                                                                                                        */
    /*  1      3       0                                                                                                      */
    /*  2      4       1                                                                                                      */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
