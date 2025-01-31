!ABCIncludeFile
OMIT('_EndOfInclude_',_CPCachedFileManager_)               !not to be compiled if that has already been done
_CPCachedFileManager_ EQUATE(1)                            !Set a flag to indicate that compile has been done
!------------------------------------------------------------------------------
! Generated by CapeSoft's Object Writer, but this template has been
! heavy modified by Bjarne Havnen and Ole Morten Heien  to support Interfaces 
! and a lot of other stuff
!-------------------------------------------------------------------------------
!This Class was generated by AdiSQLFilemanager
!Program author is Bjarne Havnen
!-------------------------------------------

  include('AbFile.Inc'),Once
!--------------------------------------------------------------------------------
!Class CPCachedFileManager
!
!--------------------------------------------------------------------------------

CPCachedFileManager  Class(FileManager), Type,Module('CPCachedFileManager.Clw'),LINK('CPCachedFileManager.Clw',_ABCLinkMode_),DLL(_ABCDllMode_)
! Properties
CacheQ                 &CPCacheQueue,Private               !
PrimaryKeyField        BYTE,Private                        !
PrimaryKeyRef          &Key,Private                        !
NoCache                BYTE                                !
! Methods
Fetch                  FUNCTION (KEY K),BYTE,PROC ,VIRTUAL 
Kill                   PROCEDURE  ,VIRTUAL 
PutCache               PROCEDURE (Key k)  ,Private
RemoveCache            PROCEDURE   ,Private
TryUpdate              FUNCTION (),BYTE,PROC ,VIRTUAL 
Update                 FUNCTION (),BYTE,PROC ,VIRTUAL 
ValidCache             FUNCTION (Key K),BYTE  ,Private
AddKey                 PROCEDURE (KEY K,STRING Description,BYTE AutoInc = 0)  
Debug                  PROCEDURE (String s)  ,Private

                     END ! Class Definition

_EndOfInclude_                                             !End of the OMIT statement part
