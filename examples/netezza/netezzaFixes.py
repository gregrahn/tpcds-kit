fname='query_0.sql'

fixes=[
{"query":"All", "operation":"in", "replaceThis":"+  14 days)"                      , "withThis":"+  interval '14 days')"      ,"reason":"Netezza date add using interval format"},
{"query":"All", "operation":"in", "replaceThis":"+  30 days)"                      , "withThis":"+  interval '30 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+  60 days)"                      , "withThis":"+  interval '60 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+  90 days)"                      , "withThis":"+  interval '90 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"-  30 days)"                      , "withThis":"-  interval '30 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+ 14 days)"                       , "withThis":"+  interval '14 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+ 30 days)"                       , "withThis":"+  interval '30 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"+ 60 days)"                       , "withThis":"+  interval '60 days')"      ,"reason":"Netezza date add using interval format"},        
{"query":"All", "operation":"in", "replaceThis":"+ 90 days)"                       , "withThis":"+  interval '90 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"All", "operation":"in", "replaceThis":"- 30 days)"                       , "withThis":"-  interval '30 days')"      ,"reason":"Netezza date add using interval format"},              
{"query":"query10.tpl", "operation":"in", "replaceThis":"3+3) or"                  , "withThis":"3+3) AND"                    ,"reason":"changed OR to AND hack to overcome [Code: 1100, SQL State: HY000]  ERROR:  (2) This form of correlated query is not supported - consider rewriting[Code: 1100, SQL State: HY000]  ERROR:  (2) This form of correlated query is not supported - consider rewriting"},
{"query":"query35.tpl", "operation":"in", "replaceThis":"d_qoy < 4) or"            , "withThis":"d_qoy < 4) AND"              ,"reason":"changed OR to AND hack to overcome [Code: 1100, SQL State: HY000]  ERROR:  (2) This form of correlated query is not supported - consider rewriting[Code: 1100, SQL State: HY000]  ERROR:  (2) This form of correlated query is not supported - consider rewriting"},
{"query":"query49.tpl", "operation":"in", "replaceThis":" order by 1,4,5,2"        , "withThis":"A order by 1,4,5,2"          ,"reason":"overcome [Code: 1100, SQL State: HY000]  ERROR:  sub-SELECT in FROM must have an alias For example, FROM (SELECT ...) [AS] foo"},
{"query":"query23.tpl", "operation":"in", "replaceThis":"group by c_customer_sk)),", "withThis":"group by c_customer_sk) A ),","reason":"overcome [Code: 1100, SQL State: HY000]  ERROR:  sub-SELECT in FROM must have an alias For example, FROM (SELECT ...) [AS] foo"},
{"query":"query23.tpl", "operation":"in", "replaceThis":"from best_ss_customer))"                    , "withThis":"from best_ss_customer)) B"                     ,"reason":"overcome [Code: 1100, SQL State: HY000]  ERROR:  sub-SELECT in FROM must have an alias For example, FROM (SELECT ...) [AS] foo"},
{"query":"query23.tpl", "operation":"in", "replaceThis":"group by c_last_name,c_first_name)"         , "withThis":"group by c_last_name,c_first_name) C"          ,"reason":"overcome [Code: 1100, SQL State: HY000]  ERROR:  sub-SELECT in FROM must have an alias For example, FROM (SELECT ...) [AS] foo"},
{"query":"query14.tpl", "operation":"eq", "replaceThis":"   and d3.d_year between 1999 AND 1999 + 2)", "withThis":"   and d3.d_year between 1999 AND 1999 + 2) A" ,"reason":"overcome [Code: 1100, SQL State: HY000]  ERROR:  sub-SELECT in FROM must have an alias For example, FROM (SELECT ...) [AS] foo"},	
{"query":"query2.tpl" , "operation":"in", "replaceThis":"from catalog_sales)),"                      , "withThis":"from catalog_sales) A ),"                      ,"reason":"overcome [Code: 1100, SQL State: HY000]  ERROR:  sub-SELECT in FROM must have an alias For example, FROM (SELECT ...) [AS] foo"}		
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