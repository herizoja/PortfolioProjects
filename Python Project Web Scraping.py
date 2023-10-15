#!/usr/bin/env python
# coding: utf-8

# In[1]:


from bs4 import BeautifulSoup
import requests


# In[2]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'


# In[3]:


page = requests.get(url)


# In[4]:


print(page)


# In[5]:


soup = BeautifulSoup(page.text, 'html')


# In[6]:


print(soup)


# In[7]:


soup.find('table')


# In[9]:


soup.find_all('table')[1]


# In[ ]:


<table class="wikitable sortable jquery-tablesorter">
<caption>


# In[10]:


table = soup.find_all('table')[1]


# In[11]:


print(table)


# In[19]:


world_title = table.find_all('th')


# In[20]:


world_title


# In[21]:


world_table_title = [title.text.strip() for title in world_title]


# In[22]:


world_table_title


# In[23]:


import pandas as pd


# In[26]:


df = pd.DataFrame(columns = world_table_title)

df


# In[28]:


column_data = table.find_all('tr')


# In[33]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    
    length = len(df)
    df.loc[length] = individual_row_data
    


# In[34]:


df


# In[ ]:




