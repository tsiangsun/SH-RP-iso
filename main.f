c     simple surface-hopping ring-polymer isomorphic Hamiltonian driver routine
      program SHRPiso
c     this module is located in sh_rp_iso_integrator.f
      use dynamics
      implicit none
      integer seed(12) 
      integer ISEED,log2bead
      double precision xcin,vcin
      real rrr
      character(20)buffer

c      read input parameters from the command line
c      initial temperature (K)
       call GETARG(1,buffer)
       read(buffer,*) temp
c      timestep (a.u.)
       call GETARG(2,buffer)
       read(buffer,*) dt
c      initial surface
       call GETARG(3,buffer)
       read(buffer,*) nsurf
c      initial centroid position (a.u.)
       call GETARG(4,buffer)
       read(buffer,*) xcin
c      initial centroid velocity (a.u.)
       call GETARG(5,buffer)
       read(buffer,*) vcin
c      log_{2}{number of beads} MUST BE NON-NEGATIVE INTEGER!
       call GETARG(6,buffer)
       read(buffer,*) log2bead
c      initial SEED
       call GETARG(7,buffer)
       read(buffer,*) ISEED

       nbead=2**log2bead
	   
c      initialize free ring-polymer quantities 
       call InitParams()

c      initialize random number generator
       seed(1)=ISEED
       call random_seed(PUT=seed)

c      initialize the free ring-polymer normal modes
       call Samplefree(xcin,vcin)

c      initialize the electronic coefficients
       call InitEl(nsurf)

c      initialize the forces for the nuclear degrees of freedom propagation
       call Force_Long()

c      all other initialization over sampled quantities go here ...

c      loop over integration steps
       do

c        integrate for a single timestep
c        using fourth-order Runge-Kutta method for the electronic coefficients
c        and alternation between velocity Verlet and free ring-polymer propagation for the nuclear degrees of freedom
         call Integrate() 

c        problem specific criterion to terminate integration goes here ...

       enddo


      stop
      end
