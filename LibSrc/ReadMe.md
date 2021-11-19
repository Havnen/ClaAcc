These files should be placed in \Clarion10\accessory\libsrc\win
Go to global embeds, after global includes embed.
Include('whatevefile.inc'),once

#Description

CpTagHandler
This is a collection of methods that I use to Tag and Untag records, or to preserve looked up data.

```Clarion
TagHandler CpTagHandler
Code
 TagHandler.AddTag(record:Id)
 Loop cnt=1 To TagHandler.Records()
    Message(TagHandler.Fetch(cnt))
 end
 
 If TagHandler.IsTagged(Record:id)
 end

```  
 


#CpCounterClass.
I use this when I need ot count multiple things and present the result.

```Clarion

counter                     cpcounterclass
InsertedCompanies           EQUATE('New companies')
UpdatedCompanies            Equate('Updated companies')
Failed                      Equate(': Failed: ')

       if Access:Companies.Insert()=Level:Benign
                counter.Increment(InsertedCompanies)
            ELSE
                counter.Increment(InsertedCompanies & Failed)
            END
       End
       !And in the end
       Message(counter.ToSTring())
```    
#CpCachedFileManager 
is used to ensure that we do not go all the way to the MSSQL for every lookup. This saves a lot of network activity for all those tables that are used for show.
Any record looked up using the primary key will be cached for 60 seconds, or until an Update is encountered. 
Override the Individual File overrides in global.

#CpTable2d
Dynamic building of a table in like a spreadsheet and present in listbox using Prop:vlbproc
Supports style, icons and tooltip.

```   
     r=Typer.GetRow(Winnertype:WinnertypeId)
        Typer.SetCellValue(r,Typer.GetColNo('Linetype'),Winnertype:CalcGroupNr)
        Typer.SetCellValue(r,Typer.GetColNo('Description'),Winnertype:Beskrivelse)
        Typer.SetCellValue(r,Typer.GetColNo(VariantType:Shortname),colval,WinVarType:SysId,style,icon,WinVarType:SourceField&Choose(Not WinVarType:WinnerType,'','  '&WinVarType:WinnerType))
        typer.SetListControl(?LIST1)
typer.SetListHeaders(?LIST1)
 ```   
 
