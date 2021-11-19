



      Member()
      Map
      Module('Debug')
  OutputDebugString(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
      End
      End ! map
      Include('CPTable2D.inc'),Once
CpLblQType          Queue,TYPE
N                       String(51)
                    END

CpColQType          QUEUE,TYPE
CellId                  Long
col                     cstring(256)
Style                   LONG
Tip                     cstring(256)
Icon                    LONG

                            end

CpRowQType          QUEUE,Type
RowId                   LONG
Cols                            &CpColQType
                            end

!-----------------------------------------------------------------------------------
  Include('Equates.clw'),once
  Include('Keycodes.clw'),once

CPTable2D.Construct  PROCEDURE                             ! Declare Procedure
  CODE
        Self.Q&=new(CpRowQType)
        Self.Lbl&=new(CpLblQType)
       
        
!-----------------------------------------------------------------------------------
CPTable2D.Rows       PROCEDURE                             ! Declare Procedure
  CODE
        return records(self.Q)
        
!-----------------------------------------------------------------------------------
CPTable2D.Columns    PROCEDURE  (Long pRow)                ! Declare Procedure
  CODE
        If pRow
            self.ValidateCell(pRow,0)
        END
        return records(self.Q.cols)
        
!-----------------------------------------------------------------------------------
CPTable2D.GetCellValue PROCEDURE  (Long r,long c)          ! Declare Procedure
  CODE
  self.ValidateCell(r,c)
  return self.q.Cols.col
   
!-----------------------------------------------------------------------------------
CPTable2D.EqualCellValue PROCEDURE  (Long r,Long c,String v) ! Declare Procedure
  CODE
        self.ValidateCell(r,c)
        if self.IgnoreBlanks 
            If Not v or not self.q.cols.col
                return TRUE
            END
        END
        
        return Choose(v=self.Q.Cols.col)
!-----------------------------------------------------------------------------------
CPTable2D.ValidateCell PROCEDURE  (Long r,Long c)          ! Declare Procedure
  CODE
        Loop while(self.Rows()<r)
            Clear(self.q)
            self.q.Cols&=new(CpColQType)
            add(self.Q)
        END
        Get(self.q,r)
        Loop while(self.Columns()<c)
            clear(self.Q.Cols.col)
            add(self.q.Cols)
        END
        get(self.Q.Cols,c)
        If c>Self.MaxColums
            Self.MaxColums=C
        END
        
        
!-----------------------------------------------------------------------------------
CPTable2D.SetCellValue PROCEDURE  (Long r,long c,String v) ! Declare Procedure
  CODE
        self.ValidateCell(r,c)        
        self.Q.Cols.col=v
        Put(self.Q.Cols)
!-----------------------------------------------------------------------------------
CPTable2D.EqualRows  PROCEDURE  (Long r1,Long r2)          ! Declare Procedure
col1cnt                    LONG
col2cnt                 LONG
maxcols                 LONG
cnt       LONG
  CODE
        self.ValidateCell(r1,0)
        col1cnt=self.Columns()
        self.ValidateCell(r2,0)
        col2cnt=self.Columns()
        maxcols=CHOOSE(col1cnt>col2cnt,col1cnt,col2cnt)
        Loop cnt=1 To maxcols
            If Not self.EqualCellValue(r1,cnt,self.GetCellValue(r2,cnt))
                return FALSE
            END
        END
        return true
!-----------------------------------------------------------------------------------
CPTable2D.SetRowId   PROCEDURE  (Long r,Long pId)          ! Declare Procedure
  CODE
        Self.ValidateCell(r,0)
        self.Q.RowId=pId
        put(self.Q)
        Return Pointer(self.Q)
        
!-----------------------------------------------------------------------------------
CPTable2D.GetRowId   PROCEDURE  (Long r)                   ! Declare Procedure
  CODE
        Self.ValidateCell(r,0)
        return Self.Q.RowId
        
        
!-----------------------------------------------------------------------------------
CPTable2D.Reset      PROCEDURE                             ! Declare Procedure
cnt                         LONG
  CODE
        Loop cnt=Self.Rows() to 1 By -1
            Get(self.Q,cnt)
            Self.DeleteRow()
        END
        
!-----------------------------------------------------------------------------------
CPTable2D.GetRow     PROCEDURE  (String p1,<String p2>,<String p3>,<String p4>,<String p5>,<String p6>,<String p7>,<String p8>,<String p9>,<String p10>) ! Declare Procedure
cnt                         LONG
ret                         LONG
parameterPosition           LONG
  CODE
         Loop cnt=1 To Records(Self.Q)
            get(Self.Q,cnt)
            if (self.EqualCellValue(cnt,1,p1))
                ret=cnt 
                Loop parameterPosition=2 To 10
                    If Omitted(parameterPosition+1) !ta høyde for førte paramseter = class
                        BREAK                       !alt var likt så langt
                    END
                    If (Not self.EqualCellValue(cnt,parameterPosition,Choose(parameterposition,'',p2,p3,p4,p5,p6,p7,p8,p9,p10)))
                        ret=0
                        BREAK
                    END
                END
            END 
            If ret !alle verdier ble funnet
                Break
            END
        END
        return ret
        
        
!-----------------------------------------------------------------------------------
CPTable2D.AddRow     PROCEDURE                             ! Declare Procedure
  CODE
        Self.ValidateCell(Self.Rows()+1,0)
        return Self.Rows()
        
!-----------------------------------------------------------------------------------
CPTable2D.GetColNo   PROCEDURE  (String n)                 ! Declare Procedure
  CODE
        self.Lbl.N=N
        get(self.Lbl,Self.Lbl.N)
        If ErrorCode()
            Add(self.Lbl)
        END
        return Pointer(self.Lbl)
        
!-----------------------------------------------------------------------------------
CPTable2D.ListBoxData PROCEDURE  (Long r,Long c)           ! Declare Procedure
nchanges                    LONG
FieldCnt                 LONG(2) !value + style
ActualField                 LONG
TipField                    Long (0)
Kol                         LONG
StyleField                  LONG
IconField                   LONG
cnt                         LONG
  CODE
        If Self.EnableIcon !then icon is first field
            StyleField=3
            FieldCnt+=1
            IconField=2
        ELSE
            StyleField=2
        END
        If Self.EnableTip
            TipField=StyleField+1 
            FieldCnt+=1
        END
        Kol=Self.GetMaxColumns()*FieldCnt !total colums
        
        CASE r

        OF -1                    ! How many rows?
            RETURN Self.Rows()

        OF -2                    ! How many columns?
            RETURN (Self.GetMaxColumns()*FieldCnt)
            
        OF -3                    ! Has it changed
            nchanges = CHANGES(SELF.Q)

            IF nchanges <> SELF.ChangesQ THEN
                SELF.ChangesQ = nchanges
                  RETURN 1
            ELSE
                RETURN 0
            END
        ELSE
!            
!            if c%2=0 !stylefield
!                return self.GetCellSTyle(r,c/2)  !hvis 6, gir 3 felt
!            ELSE
!                Return Self.GetCellValue(r,((c-1)/2)+1) !hvis 5, gir 5-1=4/2=2+1=3
!            END
            
            LOOP cnt=0 To Self.GetMaxColumns()-1
                Kol=FieldCnt*cnt
                If c=Kol+1
                    Return Self.GetCellValue(r,cnt+1) !hvis 5, gir 5-1=4/2=2+1=3
                ELSif c=Kol+IconField And Self.EnableIcon
                    Return Self.GetCellIcon(r,cnt+1)
                Elsif c=Kol+StyleField
                    Return Self.GetCellStyle(r,cnt+1)
                ELSIF c=Kol+TipField And Self.EnableTip
                    Return Self.GetCellTip(r,cnt+1)
                END
                
            END
        End
        Return ''
!-----------------------------------------------------------------------------------
CPTable2D.DisplayQueue PROCEDURE                           ! Declare Procedure
Window                      WINDOW('Caption'),AT(,,684,370),GRAY,SYSTEM,FONT('Microsoft Sans Serif',8)
                                LIST,AT(17,11,649,318),USE(?LIST1)
                            END
cnt                         LONG

  CODE
        If Self.MaxColums=0
            Message('No actual data')
        END
        
        open(Window)
        ?List1{PROP:VLBVal}=Address(self)
        ?list1{PROP:VLBProc}=Address(self.ListboxData)
        self.SetListHeaders(?List1)
        
        ACCEPT
        END
        Close(Window)
        
!-----------------------------------------------------------------------------------
CPTable2D.GetColLabel PROCEDURE  (Long c)                  ! Declare Procedure
  CODE
        get(self.Lbl,c)
        If ErrorCode()
            return c
        END
        return self.lbl.n
        
!-----------------------------------------------------------------------------------
CPTable2D.SetListControl PROCEDURE  (Long listControl)     ! Declare Procedure
  CODE
   listControl{PROP:VLBVal}=Address(self)
   listControl{PROP:VLBProc}=Address(self.ListBoxData)
   
!-----------------------------------------------------------------------------------
CPTable2D.SetListHeaders PROCEDURE  (Long l)               ! Declare Procedure
w                               LONG
cnt                             LONG
  CODE
        
        If Self.MaxColums=0 
            RETURN
        END
        l{Prop:Format}=''
        w=l{PROP:Width}/self.MaxColums
        Loop cnt=1 to self.MaxColums
            l{PROPLIST:Header,cnt}=Self.GetColLabel(cnt)
            l{PROPLIST:width,cnt}=w
            l{PROPLIST:CellStyle,cnt}=true
            l{PROPLIST:Resize,cnt}=TRUE
            l{PROPLIST:LeftOffset,cnt}=2
            l{PROPLIST:RightBorder,cnt}=TRUE
            If Self.EnableTip
                l{PROPLIST:Tip,cnt}=TRUE
                l{Prop:Tip}='-'
            END
            If Self.EnableIcon
                l{PROPLIST:IconTrn,cnt}=TRUE
            END
        END
!-----------------------------------------------------------------------------------
CPTable2D.GetRow     PROCEDURE  (*Long pId)                ! Declare Procedure
r                           LONG
  CODE
        Self.Q.RowId=pId
        get(self.Q,Self.Q.RowId)
        If ERRORCODE()
            r=self.AddRow()
            self.SetRowId(r,pId)
        END
        Return Pointer(self.Q)
        
!-----------------------------------------------------------------------------------
CPTable2D.GetCellId  PROCEDURE  (Long r,long c)            ! Declare Procedure
  CODE
  self.ValidateCell(r,c)
  return self.q.Cols.CellId
   
!-----------------------------------------------------------------------------------
CPTable2D.SetCellValue PROCEDURE  (Long r,long c,String v,Long pId,Long pStyle,Long pIcon,<String pTip>) ! Declare Procedure
  CODE
        self.ValidateCell(r,c)        
        self.Q.Cols.col=v
        self.Q.Cols.CellId=pId
        self.Q.Cols.Style=pStyle
        Self.Q.Cols.Icon=pIcon
        if Not Omitted(pTip)
            Self.Q.Cols.Tip=pTip
        END
        
        Put(self.Q.Cols)
!-----------------------------------------------------------------------------------
CPTable2D.GetCellStyle PROCEDURE  (Long r,long c)          ! Declare Procedure
  CODE
        self.ValidateCell(r,c)
       
  return self.q.Cols.Style
 
!-----------------------------------------------------------------------------------
CPTable2D.Destruct   PROCEDURE                             ! Declare Procedure
  CODE
        Self.Reset()
        Dispose(Self.Q)
        
!-----------------------------------------------------------------------------------
CPTable2D.GetMaxColumns PROCEDURE                          ! Declare Procedure
  CODE
        return Choose(Self.MaxColums>0,Self.MaxColums,1)
        
!-----------------------------------------------------------------------------------
CPTable2D.GetCellicon PROCEDURE  (Long r,long c)           ! Declare Procedure
  CODE
        self.ValidateCell(r,c)
       
  return self.q.Cols.Icon
 
!-----------------------------------------------------------------------------------
CPTable2D.GetCellTip PROCEDURE  (Long r,long c)            ! Declare Procedure
  CODE
        self.ValidateCell(r,c)
       
  return self.q.Cols.Tip
 
!-----------------------------------------------------------------------------------
CPTable2D.DeleteRow  PROCEDURE  (Long pRowId)              ! Declare Procedure
  CODE
        if pRowId
            self.Q.RowId=pRowId
            get(self.Q, Self.Q.RowId)
            If ERRORCODE()
                RETURN
            END
            Self.DeleteRow()
           
        END    
     
        
!-----------------------------------------------------------------------------------
CPTable2D.DeleteRow  PROCEDURE                             ! Declare Procedure
  CODE
             Free(Self.Q.Cols)
            DISPOSE(self.Q.Cols)
            Self.Q.Cols&=NULL
            Delete(self.Q)
!-----------------------------------------------------------------------------------
!-------------------------------------------------------------------------------------
