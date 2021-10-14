These files should be placed in \Clarion10\accessory\libsrc\win
Go to global embeds, after global includes embed.
Include('whatevefile.inc'),once

#Description

CpTagHandler
This is a collection of methods that I use to Tag and Untag records, or to preserve looked up data.
TagHandler CpTagHandler
Code
 TagHandler.AddTag(record:Id)
 Loop cnt=1 To TagHandler.Records()
    Message(TagHandler.Fetch(cnt)
 end
 
 If TagHandler.IsTagged(Record:id)
 end
  
 


#CpCounterClass.
I use this when I need ot count multiple things and present the result.
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
       And in the end
       Message(counter.ToSTring())
       
