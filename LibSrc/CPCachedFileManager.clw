



      Member()
      Map
      Module('Debug')
  OutputDebugString(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
      End
      End ! map
      Include('CPCachedFileManager.inc'),Once
CPCacheQueue   queue,TYPE
KeyValue            LONG
RestoreHandle       USHORT
LastAccess        Long

END

!-----------------------------------------------------------------------------------
  Include('Equates.clw'),once
  Include('Keycodes.clw'),once

CPCachedFileManager.Fetch PROCEDURE  (KEY K)               ! Declare Procedure
ReturnValue Byte
  CODE
        If Self.ValidCache(K)
            return Level:Benign
        END
        Watch(Self.File)
        ReturnValue=Parent.Fetch(k)
        If ReturnValue=Level:Benign
            Self.PutCache(K)
        END
        REturn ReturnValue
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.Update PROCEDURE                       ! Declare Procedure
  CODE
        Self.RemoveCache()
        Return Parent.Update()
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.TryUpdate PROCEDURE                    ! Declare Procedure
  CODE
        Self.REmoveCache()
        Return Parent.TryUpdate()
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.ValidCache PROCEDURE  (KEY k)          ! Declare Procedure
grp                                 &GROUP
ref                                 ANY

  CODE
        If Self.NoCache
            RETURN False
        END
        
        If Not Self.PrimaryKeyField
            return False
        END
        If Self.PrimaryKeyRef&=k
            grp&=Self.File{PROP:Record}
            ref&=What(grp,Self.PrimaryKeyField)
            if (ref=0) 
                Return FALSE
            END
            
            Self.CacheQ.KeyValue=Ref
            Get(Self.CacheQ,Self.CacheQ.KeyValue)
            If ERRORCODE()
                return false
            Elsif Self.CacheQ.LastAccess<(Clock()-6000)
                Self.Debug('cache time out')
                Self.RestoreFile(Self.CacheQ.RestoreHandle,False)
                Delete(Self.CacheQ)
                return FALSE
            ELSE
                Self.RestoreFile(Self.CacheQ.RestoreHandle,True)
                Self.Cacheq.RestoreHandle=Self.SaveFile()
                Put(Self.CacheQ)
                Self.Debug('valid cache '&Self.CacheQ.KeyValue)
                return TRUE
            END
            
        End   
         Return False
!-----------------------------------------------------------------------------------
CPCachedFileManager.RemoveCache PROCEDURE                  ! Declare Procedure
grp                                 &GROUP
ref                                 ANY
  CODE
       If Self.NoCache
            RETURN
        END
        
        If Not Self.PrimaryKeyField
            return
        END
        grp&=Self.File{PROP:Record}
        ref&=What(grp,Self.PrimaryKeyField)
        Self.CacheQ.KeyValue=Ref
        Get(Self.CacheQ,Self.CacheQ.KeyValue)
        If Not ERRORCODE()
            Self.RestoreFile(Self.CacheQ.RestoreHandle,false)
            Delete(Self.CacheQ)
            Self.Debug('Remove cache '&Self.CacheQ.KeyValue)
        END
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.PutCache PROCEDURE  (Key k)            ! Declare Procedure
grp                                 &GROUP
ref                                 ANY
  CODE
        If Self.NoCache
            RETURN
        END
        
        If Not Self.PrimaryKeyField
            
               return 
            END
        If Self.PrimaryKeyRef&=k
            grp&=Self.File{PROP:Record}
            ref&=What(grp,Self.PrimaryKeyField)
            Self.CacheQ.KeyValue=Ref
            Get(Self.CacheQ,Self.CacheQ.KeyValue)
            If Not Errorcode()
                Self.RestoreFile(Self.CacheQ.RestoreHandle,false)
                Delete(Self.CacheQ)
            END
            Self.CacheQ.RestoreHandle=Self.SaveFile()
            Self.CacheQ.LastAccess=Clock()
            Add(Self.CacheQ)
        ELSE
            grp&=Self.File{PROP:Record}
            ref&=What(grp,Self.PrimaryKeyField)
            Self.CacheQ.KeyValue=Ref
            Get(Self.CacheQ,Self.CacheQ.KeyValue)
            If Not Errorcode()
                Self.RestoreFile(Self.CacheQ.RestoreHandle,false)
                Delete(Self.CacheQ)
            END
        END
        
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.Kill PROCEDURE                         ! Declare Procedure
cnt                             LONG
  CODE
        If Self.PrimaryKeyField
            Free(Self.CacheQ)
            Dispose(Self.CacheQ)
        END
        
        Parent.Kill()
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.AddKey PROCEDURE  (KEY K,STRING Description,BYTE AutoInc = 0) ! Declare Procedure
  CODE
        Parent.AddKey(k,description,autoInc)
        If NOt Self.PrimaryKeyField And Self.File{PROP:Driver}='MSSQL' And Self.PrimaryKey And k{PROP:Primary}=true
            Self.PrimaryKeyField = k{PROP:Field,1}
            Self.PrimaryKeyRef &=k
            Self.CacheQ &=new CPCacheQueue
             
        END
        
        
!-----------------------------------------------------------------------------------
CPCachedFileManager.Debug PROCEDURE  (String s)            ! Declare Procedure
ut Cstring(512)
  CODE
        Ut = 'CPCachedFileManager '&Self.File{Prop:Name}&' '&s
        OutputDebugString(ut)
      
!-----------------------------------------------------------------------------------
!-------------------------------------------------------------------------------------
