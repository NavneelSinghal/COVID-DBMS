import csv

list1=[]
dist_pop=[]

with open('input/india-districts-census-2011.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    
    for row in csv_reader:
        
        if line_count == 0:
            line_count=line_count+1
        else:
            dist_pop.append([row[2],row[3],row[1]])

with open('input/district_wise.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0

    for row in csv_reader:
        if line_count == 0:
            line_count += 1
            row1=row
            scode_index=row1.index('State_Code')
            dcode_index=row1.index('District_Key')
            key_index=row1.index('SlNo')
            state_name=row1.index('State')
        else:
            line_count += 1
            temp=''
            for l in dist_pop:
                # print(l,row[dcode_index])
                if l[0]==row[dcode_index][3:] and (l[2].lower())==(row[state_name].lower()):
                    temp=l[1]
            list1.append([row[scode_index],row[dcode_index],row[key_index],row[state_name],temp])

            

state=[]
# with open('state_id.csv', 'w', newline='') as file:
    # writer = csv.writer(file)
dict={}
j=0
for i in range(len(list1)):
    l1=(list1[i][0],list1[i][3])
    dict[l1]=0



l=['State_id','State_Code','State']
# writer.writerow(l)

for key in dict:
    l2=[j,key[0],key[1]]
    j=j+1
    # writer.writerow(l2)
    state.append(l2)

dist=[]




           


with open('output/district.csv','w',newline='') as file:
    writer = csv.writer(file)
    l=['District_id','District','State_id','Population']
    writer.writerow(l)
    list1.sort(key=lambda list1: list1[3])
    for i in range(len(list1)):
        temp=''
        for j in state:
            if j[2]==list1[i][3]:
                temp=j[0]
        l2=[i,list1[i][1][3:],temp,list1[i][4]]
        writer.writerow(l2)
        dist.append(l2)

dist_daily=[]
for d in dist:
    dist_daily.append([d[0],d[1],d[2],d[3],0,0,0,0])

with open('output/district_daily.csv','w',newline='') as file:
    with open('input/districts.csv') as csv_file:
        writer = csv.writer(file)
        writer.writerow(['date_1','District_id','Confirmed','Recovered','Deceased','Other'])
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        date=''
        prev_dist_daily=[x[:] for x in dist_daily]
        for row in csv_reader:
            #if line_count>1000:
             #   break
            if line_count==0:
                line_count=line_count+1
                state_index=row.index('State')
                district_index=row.index('District')
                confirmed_index=row.index('Confirmed')
                recovered_index=row.index('Recovered')
                deceased_index=row.index('Deceased')
                other_index=row.index('Other')
                # tested_index=row.index('Tested')
                date_index=row.index('Date')
            else:
                new_date=row[date_index]
                if line_count==1:
                    date=new_date
                if new_date!=date:
                    for i in range(len(dist_daily)):
                        l2=[date]+(dist_daily[i])
                        l2[5]=int(dist_daily[i][4])-int(prev_dist_daily[i][4])
                        l2[6]=int(dist_daily[i][5])-int(prev_dist_daily[i][5])
                        l2[7]=int(dist_daily[i][6])-int(prev_dist_daily[i][6])
                        l2[8]=int(dist_daily[i][7])-int(prev_dist_daily[i][7])
                        l3=l2[0:2]+l2[5:]
                        writer.writerow(l3)
                    prev_dist_daily=[x[:] for x in dist_daily]
                    date=new_date
                for i in range(len(dist_daily)):
                    if dist_daily[i][2]==row[2] and dist_daily[i][3]==row[1]:
                        # print('dist',dist_daily[i])
                        # print('prev',prev_dist_daily[i])
                        dist_daily[i][4]=row[confirmed_index]
                        dist_daily[i][5]=row[recovered_index]
                        dist_daily[i][6]=row[deceased_index]
                        dist_daily[i][7]=row[other_index]
                        # print('dist',dist_daily[i])
                        # print('prev',prev_dist_daily[i])
                        break
                line_count=line_count+1
                if line_count%1000==0:
                    print(line_count)
                    


with open('output/state_daily.csv','w',newline='') as file:
    with open('input/states.csv') as csv_file:
        writer = csv.writer(file)
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        date='2020-04-26'
        state_daily=[]
        # writer.writerow(['Date','State_id','State_Code','State','Confirmed','Recovered','Deceased','Tested'])
        writer.writerow(['date_1','State_id','Confirmed','Recovered','Deceased','Other','Tested'])
        for s in state:
            state_daily.append(s+[0,0,0,0,0])
        prev_state_daily=[x[:] for x in state_daily]
        for row in csv_reader:
            # if line_count>100000:
            #     break
            if line_count==0:
                line_count=line_count+1
                state_index=row.index('State')
                date_index=row.index('Date')
                tested_index=row.index('Tested')
                confirmed_index=row.index('Confirmed')
                recovered_index=row.index('Recovered')
                deceased_index=row.index('Deceased')
                other_index=row.index('Other')
            else:
                new_date=row[date_index]                    
                if new_date<'2020-04-26':
                    continue
                if new_date!=date:
                    for i in range(len(state_daily)):
                        l2=[date]+state_daily[i]
                        # print(l2)
                        l2[4]=int(state_daily[i][3])-int(prev_state_daily[i][3])
                        l2[5]=int(state_daily[i][4])-int(prev_state_daily[i][4])
                        l2[6]=int(state_daily[i][5])-int(prev_state_daily[i][5])
                        l2[7]=int(state_daily[i][6])-int(prev_state_daily[i][6])
                        l2[8]=int(state_daily[i][7])-int(prev_state_daily[i][7])
                        l3=l2[0:2]+l2[4:]
                        writer.writerow(l3)
                        # writer.writerow(l2)
                    prev_state_daily=[x[:] for x in state_daily]
                    date=new_date
                for i in range(len(state_daily)):
                    if row[state_index]==state_daily[i][2]:
                        state_daily[i][3]=row[confirmed_index]
                        state_daily[i][4]=row[recovered_index]
                        state_daily[i][5]=row[deceased_index]
                        state_daily[i][6]=row[other_index]
                        state_daily[i][7]=row[tested_index]

                        if row[other_index]=='':
                            state_daily[i][6]='0'
                        if row[confirmed_index]=='':
                            state_daily[i][3]='0'
                        if row[recovered_index]=='':
                            state_daily[i][4]='0'
                        if row[deceased_index]=='':
                            state_daily[i][5]='0'
                        if row[tested_index]=='':
                            state_daily[i][7]='0'

with open('output/vaccine_daily.csv','w',newline='') as file:
    with open('input/cowin_vaccine_data_statewise.csv') as csv_file:
        writer = csv.writer(file)
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        list2=[]
        for row in csv_reader:
            if line_count==0:
                row[0]='date_1'
                row[1]='State_id'
                for i in range(2,len(row)):
                    for j in range(len(row[i])-1):
                        if row[i][j]==' ' or row[i][j]=='(':
                            row[i]=row[i][:j]+'_'+row[i][j+1:]
                    if row[i][len(row[i])-1]==')':
                        row[i]=row[i][:len(row[i])-1]
                writer.writerow(row)
                line_count=line_count+1
            else:
                index1=row[0].find('/')
                temp=row[0][0:index1]
                if len(temp)==1:
                    temp='0'+temp
                row[0]=row[0][index1+1:]
                index2=row[0].find('/')
                temp=row[0][0:index2]+'-'+temp
                if len(temp)==4:
                    temp='0'+temp
                temp=row[0][index2+1:]+'-'+temp
                row[0]=temp
                list2.append(row)
        list2.sort(key=lambda list2:list2[0])
        date=list2[0][0]
        state_daily=[]
        for s in state:
            state_daily.append(s+[0 for i in range(12)])
        # print(state_daily)
        prev_state_daily=[x[:] for x in state_daily]
        for l in list2:
            # print(l)
            new_date=l[0]
            if date!=new_date:
                for i in range(len(state_daily)):
                    l2=[date]+state_daily[i]
                    for j in range(12):
                        l2[j+4]=int(state_daily[i][j+3])-int(prev_state_daily[i][j+3])
                    l3=l2[0:2]+l2[4:]
                    writer.writerow(l3)
                prev_state_daily=[x[:] for x in state_daily]
                date=new_date
            for i in range(len(state_daily)):
                if l[1]==state_daily[i][2]:
                    for j in range(12):
                        state_daily[i][j+3]=l[j+2]
                        if l[j+2]=='':
                            state_daily[i][j+3]=0


# print(dist_pop)






