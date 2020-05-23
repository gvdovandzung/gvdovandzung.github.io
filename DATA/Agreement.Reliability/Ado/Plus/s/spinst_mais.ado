*! version 1.0.2  06aug2009
program spinst_mais
  version 9

  di as smcl "{txt}Installing ..."

  cap noi spinst_mais_wrk sbe24_3 http://www.stata-journal.com/software/sj9-2
  cap noi spinst_mais_wrk sbe22_1 http://www.stata-journal.com/software/sj9-1
  cap noi spinst_mais_wrk sbe28_1 http://www.stata.com/stb/stb56
  cap noi spinst_mais_wrk sbe23_1 http://www.stata-journal.com/software/sj8-4
  cap noi spinst_mais_wrk st0061 http://www.stata-journal.com/software/sj4-2
  cap noi spinst_mais_wrk gr0033_1 http://www.stata-journal.com/software/sj9-2
  cap noi spinst_mais_wrk sbe19_6 http://www.stata-journal.com/software/sj9-2
  cap noi spinst_mais_wrk sbe39_2 http://www.stata.com/stb/stb61
  cap noi spinst_mais_wrk st0163 http://www.stata-journal.com/software/sj9-2
  cap noi spinst_mais_wrk st0096_2 http://www.stata-journal.com/software/sj9-2
  cap noi spinst_mais_wrk st0157 http://www.stata-journal.com/software/sj9-1
  cap noi spinst_mais_wrk st0156 http://www.stata-journal.com/software/sj9-1

  if "`haserr'" != "" {
    di
    di in smcl "{p}{err}At least one of the packages was not able to be " ///
               "installed.  Try typing {cmd:spinst_mais} again.  If that " ///
               "fails, look at the output of the error message above to " ///
               "diagnose the problem.  Perhaps you have an out-of-date " ///
               "version of the package already installed.  In that case, " ///
               "type {cmd:adoupdate} to update it."
  }
  else {
   di as smcl "{txt}Installation complete."
  }
end

program spinst_mais_wrk
  version 9
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

