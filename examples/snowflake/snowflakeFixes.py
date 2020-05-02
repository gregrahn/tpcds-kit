fname='query_0.sql'

fixes=[
{"query":"All", "operation":"in", "replaceThis":"+  14 days)"                      , "withThis":"+  interval '14 days')"      ,"reason":"Snowflake date add using interval format"},
{"query":"All", "operation":"in", "replaceThis":"+  30 days)"                      , "withThis":"+  interval '30 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+  60 days)"                      , "withThis":"+  interval '60 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+  90 days)"                      , "withThis":"+  interval '90 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"-  30 days)"                      , "withThis":"-  interval '30 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+ 14 days)"                       , "withThis":"+  interval '14 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+ 30 days)"                       , "withThis":"+  interval '30 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+ 60 days)"                       , "withThis":"+  interval '60 days')"      ,"reason":"Snowflake date add using interval format"},        
{"query":"All", "operation":"in", "replaceThis":"+ 90 days)"                       , "withThis":"+  interval '90 days')"      ,"reason":"Snowflake date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"- 30 days)"                       , "withThis":"-  interval '30 days')"      ,"reason":"Snowflake date add using interval format"}
]

startDelimiter = '-- start query'
endDelimiter = '-- end query'

with open('query_0.sql') as fin: 
   lines = fin.readlines()

counter = 0
currentQuery = ""
query = ""
for line in lines:
  line = line.rstrip()
  counter = counter + 1
  
  if startDelimiter in line:
    #reverse string, slice at first space, take first piece and reverse it to get the query
    reverse=line[::-1]
    query=reverse[:reverse.find(" ")]
    query=query[::-1]
    query=query.strip()
    #print (query)
  
  for fix in fixes:
    #print(query + ": " + fix["query"])
    if query == fix["query"] or fix["query"] == 'All':
        if fix["operation"] == "in":
            if fix["replaceThis"] in line:
                line = line.replace(fix["replaceThis"], fix["withThis"])
        if fix["operation"] == "eq":
            if fix["replaceThis"] == line:
                line = line.replace(fix["replaceThis"], fix["withThis"])
  print (line.rstrip())