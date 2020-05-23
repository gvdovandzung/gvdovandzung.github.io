*! version 1.0.0  02feb2009
program spinst_itsp
  version 10.1

  di as smcl "{txt}Installing ..."

  cap noi spinst_itsp_wrk egenmore http://fmwww.bc.edu/repec/bocode/e
  cap noi spinst_itsp_wrk estout http://fmwww.bc.edu/repec/bocode/e
  cap noi spinst_itsp_wrk freduse http://fmwww.bc.edu/repec/bocode/f
  cap noi spinst_itsp_wrk ivreg2 http://fmwww.bc.edu/repec/bocode/i
  cap noi spinst_itsp_wrk mat2txt http://fmwww.bc.edu/repec/bocode/m
  cap noi spinst_itsp_wrk makematrix http://fmwww.bc.edu/repec/bocode/m
  cap noi spinst_itsp_wrk moremata http://fmwww.bc.edu/repec/bocode/m
  cap noi spinst_itsp_wrk mvsumm http://fmwww.bc.edu/repec/bocode/m
  cap noi spinst_itsp_wrk onespell http://fmwww.bc.edu/repec/bocode/o
  cap noi spinst_itsp_wrk outreg2 http://fmwww.bc.edu/repec/bocode/o
  cap noi spinst_itsp_wrk outtable http://fmwww.bc.edu/repec/bocode/o
  cap noi spinst_itsp_wrk psmatch2 http://fmwww.bc.edu/repec/bocode/p
  cap noi spinst_itsp_wrk ranktest http://fmwww.bc.edu/repec/bocode/r
  cap noi spinst_itsp_wrk sphdist http://fmwww.bc.edu/repec/bocode/s
  cap noi spinst_itsp_wrk statsmat http://fmwww.bc.edu/repec/bocode/s
  cap noi spinst_itsp_wrk textbarplot http://fmwww.bc.edu/repec/bocode/t
  cap noi spinst_itsp_wrk tscollap http://fmwww.bc.edu/repec/bocode/t
  cap noi spinst_itsp_wrk tsmktim http://fmwww.bc.edu/repec/bocode/t

  if "`haserr'" != "" {
    di
    di in smcl "{p}{err}At least one of the packages was not able to be " ///
               "installed.  Try typing {cmd:spinst_itsp} again.  If that " ///
               "fails, look at the output of the error message above to " ///
               "diagnose the problem.  Perhaps you have an out-of-date " ///
               "version of the package already installed.  In that case, " ///
               "type {cmd:adoupdate} to update it."
  }
  else {
   di as smcl "{txt}Installation complete."
  }
end

program spinst_itsp_wrk
  version 10.1
  args package from

  di as smcl "{txt}   package {res:`package'} from {res:`from'}"
  capture net install `package', from(`from')
  if _rc {
    di
    di as smcl "{cmd}. net install `package', from(`from')
    capture noisily net install `package', from(`from')
    di
    if _rc {
      c_local haserr "yes"
    }
  }
end

