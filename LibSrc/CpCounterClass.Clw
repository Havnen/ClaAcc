



      Member()
CounterQueueType    Queue,TYPE
KeyName                 String(255)
Count                   Long
                    END
      Map
      Module('Debug')
  OutputDebugString(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
      End
      End ! map
      Include('CpCounterClass.inc'),Once

!-----------------------------------------------------------------------------------
  Include('Equates.clw'),once
  Include('Keycodes.clw'),once

CpCounterClass.Increment PROCEDURE  (String k)             ! Declare Procedure
  CODE
        Self.AddNew(k)
        
        Self.Q.Count+=1
        Put(Self.Q)
        Return Self.Q.count
        
!-----------------------------------------------------------------------------------
CpCounterClass.Construct PROCEDURE                         ! Declare Procedure
  CODE
        Self.Q &=new(CounterQueueType)
        
!-----------------------------------------------------------------------------------
CpCounterClass.Destruct PROCEDURE                          ! Declare Procedure
  CODE
        Free(Self.Q)
        Dispose(Self.Q)
        
        
!-----------------------------------------------------------------------------------
CpCounterClass.Decrement PROCEDURE  (String k)             ! Declare Procedure
  CODE
        Self.AddNew(k)
        
        Self.Q.Count-=1
        Put(Self.Q)
        return Self.Q.Count
        
!-----------------------------------------------------------------------------------
CpCounterClass.ToString PROCEDURE                          ! Declare Procedure
cnt                         Long
RetValue                    Cstring(10000)
sep                         cstring(5)
  CODE
         Loop cnt=1 To Records(Self.Q)
            Get(Self.Q,Cnt)
            RetValue = RetValue & sep &Self.ToString(Self.Q.KeyName)
            sep = '|'
        END
        Return RetValue
        
        
!-----------------------------------------------------------------------------------
CpCounterClass.ToString PROCEDURE  (String k)              ! Declare Procedure
pct                         Cstring(11)
  CODE
      
        Self.Q.KeyName=K
        Get(Self.Q,Self.Q.KeyName)
        If Errorcode()
            Return ''
        END
        Return (Sub(Self.Q.KeyName,1,Self.MaxKeyName)&' = '&Self.Q.Count)
        
!-----------------------------------------------------------------------------------
CpCounterClass.AddNew PROCEDURE  (String k)                ! Declare Procedure
  CODE
        Self.Q.KeyName=Clip(Left(K))
        Get(Self.Q,Self.Q.Keyname)
        If Errorcode()
            Self.Q.Count=0
            Add(Self.Q)
            If (Len(Clip(Self.Q.KeyName))>Self.MaxKeyname)
                Self.MaxKeyName=Len(Clip(Self.Q.KeyName))
            END 
        END
        
!-----------------------------------------------------------------------------------
CpCounterClass.Records PROCEDURE                           ! Declare Procedure
  CODE
        return records(Self.Q)
        
!-----------------------------------------------------------------------------------
!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
CpCounterClass.FetchName PROCEDURE  (Long p)               ! Declare Procedure

  CODE
        get(Self.Q,p)
        return Self.Q.KeyName
        
!-----------------------------------------------------------------------------------
CpCounterClass.FetchCount PROCEDURE  (Long p)              ! Declare Procedure
  CODE
        Get(Self.Q,p)
        return Self.Q.Count
        
        
!-----------------------------------------------------------------------------------
!-------------------------------------------------------------------------------------
