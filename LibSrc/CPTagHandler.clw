



      Member()
      Map
      Module('Debug')
  OutputDebugString(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
      End
      End ! map
      Include('CPTagHandler.inc'),Once
 INCLUDE('CWSYNCHC.INC'),ONCE

!-----------------------------------------------------------------------------------
  Include('Equates.clw'),once
  Include('Keycodes.clw'),once

CPTagHandler.Init    PROCEDURE  (*CPTagQueueType pTags)    ! Declare Procedure
  CODE
        Self.Q&=pTags
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddTag  PROCEDURE  (Long p,String  p2)        ! Declare Procedure
n                           String(20)
ref                         ANY
  CODE
        Self.QueueLock.Wait()
        Self.AddTagInternal(p)
     
        Self.AddParameter(2,p2)
        put(SElf.Q)
        Self.QueueLock.Release()
!-----------------------------------------------------------------------------------
CPTagHandler.AddTag  PROCEDURE  (Long p,String p2, String p3) ! Declare Procedure
  CODE
        Self.QueueLock.Wait()
        Self.AddTagInternal(p)
        Self.AddParameter(2,p2)
        Self.AddParameter(3,p3)
        put(SElf.Q)
        Self.QueueLock.Release()
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddTag  PROCEDURE  (Long p,String p2, String p3,String p4) ! Declare Procedure
  CODE
        Self.QueueLock.Wait()
        Self.AddTagInternal(p)
        Self.AddParameter(2,p2)
        Self.AddParameter(3,p3)
        Self.AddParameter(4,p4)
        put(SElf.Q)
        Self.QueueLock.Release()
!-----------------------------------------------------------------------------------
CPTagHandler.AddTag  PROCEDURE  (Long p,String p2, String p3, String p4, String p5) ! Declare Procedure
  CODE
        Self.QueueLock.Wait()
        Self.AddTagInternal(p)
        Self.AddParameter(2,p2)
        Self.AddParameter(3,p3)
        Self.AddParameter(4,p4)
        Self.AddParameter(5,p5)
        put(SElf.Q)
        Self.QueueLock.Release()
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddTag  PROCEDURE  (Long p,String p2, String p3,String p4,String p5,String p6) ! Declare Procedure
  CODE
        Self.QueueLock.Wait()
        Self.AddTagInternal(p)
     
        Self.AddParameter(2,p2)
        Self.AddParameter(3,p3)
        Self.AddParameter(4,p4)
        Self.AddParameter(5,p5)
        Self.AddParameter(6,p6)
        put(SElf.Q)
        Self.QueueLock.Release()
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddTag  PROCEDURE  (Long p)                   ! Declare Procedure
ref                         ANY
  CODE
        Self.QueueLock.Wait()   
        Self.AddTagInternal(p)
     
        Self.QueueLock.Release()
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddParameter PROCEDURE  (Long pDim,String pVal) ! Declare Procedure
n                           String(20)
ref                         ANY
  CODE

        n = Who(Self.Q,pDim)
        If n<>''
            ref &=What(SElf.Q,pDim)
            ref = pVal
          END
!-----------------------------------------------------------------------------------
CPTagHandler.Init    PROCEDURE                             ! Declare Procedure
  CODE
        If Self.Inited
            REturn
        End
        Self.q&=new(CPTagQueueType)
        Self.Inited=TRUE
        
!-----------------------------------------------------------------------------------
CPTagHandler.Destruct PROCEDURE                            ! Declare Procedure
  CODE
        If Self.Inited
            DISPOSE(Self.Q)
            Self.Q&=NULL
        END
         Dispose(Self.QueueLock)
       
!-----------------------------------------------------------------------------------
CPTagHandler.Toggle  PROCEDURE  (Long p)                   ! Declare Procedure
  CODE
        If Not Self.IsTagged(p)
            Self.AddTag(p)
        ELSE
            Self.RemoveTag(p)
        END
        
!-----------------------------------------------------------------------------------
CPTagHandler.IsTagged PROCEDURE  (Long p)                  ! Declare Procedure
  CODE
        
        If Self.Q&=null 
            Return False
        END
        
        Self.Q.Tagged=p    
        Get(Self.Q,Self.Q.Tagged)

        If ERRORCODE() 
            return false
        ELSE
            return true
        END
!-----------------------------------------------------------------------------------
CpTagHandler.RemoveTag PROCEDURE  (Long p)                 ! Declare Procedure
  CODE
        If Self.Q&=null Then Return.
        Self.QueueLock.Wait()
     
        If (Self.IsTagged(p))
            Delete(Self.Q)
        END
        Self.QueueLock.Release()
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddTags PROCEDURE  (*CPTagQueueType pTags)    ! Declare Procedure
cnt                         LONG
  CODE
        Loop cnt=1 To Records(pTags)
            get(pTags,cnt)
            Self.AddTag(pTags.Tagged)
        END
        
!-----------------------------------------------------------------------------------
CpTagHandler.Records PROCEDURE                             ! Declare Procedure
retVal Long(0)
  CODE
        If Not Self.Q&=NULL
            retVal = Records(Self.Q)
        END
        return retVal
        
!-----------------------------------------------------------------------------------
!!! <summary>
!!! Generated from procedure template - Source
!!! Fetch tag on position, returns tagvalue
!!! </summary>
CpTagHandler.Fetch   PROCEDURE  (Long idx)!LONG            ! Declare Procedure
RetVal Long

  CODE
        If Not Self.Q&=null
            Self.QueueLock.Wait()
     
            Get(Self.Q,idx)
            If Not Errorcode()
                RetVal= Self.Q.Tagged
            END
            Self.QueueLock.Release()
        END
        return RetVal
        
!-----------------------------------------------------------------------------------
CpTagHandler.Construct PROCEDURE                           ! Declare Procedure
  CODE
    Self.QueueLock&=new(CriticalSection)
        
!-----------------------------------------------------------------------------------
CPTagHandler.AddTagInternal PROCEDURE  (Long p)            ! Declare Procedure
ref                         ANY
  CODE
        If Self.Q&=NULL
            Self.Init()
        END
        
        Self.Q.Tagged=p    
        Get(Self.Q,Self.Q.Tagged)
        If ERRORCODE()
            Add(Self.Q)
        END
         
!-----------------------------------------------------------------------------------
CpTagHandler.Reset   PROCEDURE                             ! Declare Procedure
  CODE
        If Self.Q&=NULL
            Self.Init()
        Else
            Free(Self.Q)
        END
        
        
!-----------------------------------------------------------------------------------
CPTagHandler.CreateSqlInStatement PROCEDURE  (String pField) ! Declare Procedure
cnt                                     long
sep                                     Cstring(2)
filterSTring                            cstring(2000)
  CODE
        Loop cnt=1 To Self.Records()
            filterString = filterString&sep&Self.Fetch(cnt)
            sep=','
        END
        filterstring = 'SQL('&pfield&' IN('&filterString&'))'
        return filterString
        
!-----------------------------------------------------------------------------------
CPTagHandler.CreateSqlInStatement PROCEDURE  (String context, String pField) ! Declare Procedure
cnt                                     long
sep                                     Cstring(2)
filterSTring                            cstring(2000)
  CODE
        Loop cnt=1 To Self.Records()
            filterString = filterString&sep&Self.Fetch(cnt)
            sep=','
        END
        filterstring = pfield&' IN('&filterString&')'
        if (context)
            filterstring=context&' ('&filterstring&')'
        END
        
        return filterString
        
!-----------------------------------------------------------------------------------
!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
CpTagOnce.Construct  PROCEDURE                             ! Declare Procedure

  CODE
        Self.MyQ&=new(CpTagOnceQueueType)
        self.Init(self.MyQ)
        
!-----------------------------------------------------------------------------------
CpTagOnce.Destruct   PROCEDURE                             ! Declare Procedure
  CODE
        DISPOSE(Self.MyQ)
        
!-----------------------------------------------------------------------------------
CpTagOnce.TagOnce    PROCEDURE  (Long pId,String p2)       ! Declare Procedure
  CODE
         If self.IsTagged(pid)
            return self.MyQ.Value
        END
        self.AddTag(pId,p2)
        return p2
        
!-----------------------------------------------------------------------------------
CpTagHandler.AddTags PROCEDURE  (CpTagHandler pTagHandler) ! Declare Procedure
cnt                         LONG
  CODE
        Loop cnt=1 To pTagHandler.Records()
            Self.AddTag(pTagHandler.Fetch(cnt))
            If Size(Self.Q)=Size(pTagHandler.Q)
                Self.QueueLock.Wait()
                Self.Q = pTagHandler.Q
                Put(Self.Q)
                Self.QueueLock.Release()
            END
        END
        
        
            
!-----------------------------------------------------------------------------------
CpTagHandler.DisplayQueue PROCEDURE                        ! Declare Procedure
Window WINDOW('Display tag queue'),AT(,,397,272),FONT('Verdana',,,,CHARSET:ANSI),GRAY,RESIZE
       LIST,AT(2,5,393,241),USE(?Listqueue),HVSCROLL,FORMAT('40L(2)|M~Heder~@s255@'),FROM(Self.Q)
       STRING(''),AT(5,254),USE(?strAnt)
       BUTTON,AT(346,255,45,14),USE(?Button1),LEFT,ICON('lsexit.ico'),STD(Std:Close)
     END
i long
OrigFormat Cstring(1024)
FormatString Cstring(1024)
Ref Any
  CODE
        If Self.Q&=NULL
            RETURN
        END
        
     
  Open(Window)
  ?StrAnt{Prop:Text}=Records(Self.Q)&' records'
  ORigFormat = ?ListQueue{Proplist:format,1}
   i=0
   Loop
     I+=1
     Ref &=What(Self.Q,i)
     If Ref&=NULL
        Break
     End
     If Not ?ListQueue{Proplist:Exists,i}
        ?ListQueue{Prop:Format}= ?ListQueue{Prop:Format}&ORigFormat
     End
     ?listQueue{proplist:header,i}=Sub(Who(Self.Q,i),Instring(':',Who(Self.Q,i))+1,Len(Who(Self.Q,i)))
     ?listQueue{proplist:fieldno,i}=i
     ?listQueue{proplist:width,i}=40
     ?listQueue{proplist:picture,i}= '@S255'
     ?listQueue{proplist:rightborder,i}=true
    ?listQueue{proplist:resize,i}=true
 
    ?listQueue{proplist:leftoffset,i}=2
     ?listQueue{proplist:headerleftoffset,i}=2

  End!Loop
        ACCEPT
        End
        
           
!-----------------------------------------------------------------------------------
!-------------------------------------------------------------------------------------
