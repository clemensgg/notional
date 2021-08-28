import re
import sys


from bs4 import BeautifulSoup
from selenium import webdriver

import time

# url of the page we want to scrape
url = sys.argv[1]
print(url,'sdaf')




    # initiating the webdriver. Parameter includes the path of the webdriver.
driver = webdriver.Chrome('/usr/bin/chromedriver')
driver.get(url)



# this is just to ensure that the page is loaded
time.sleep(5)

html = driver.page_source

# this renders the JS code and stores all
# of the information in static HTML code.

# Now, we could simply apply bs4 to html variable
soup = BeautifulSoup(html, "html.parser")
driver.close()
a_tags = soup.findAll('a', {'href': re.compile(".*.tar.*")})
files = []

for t in a_tags:
    file = t['href']
    if re.match(".*tar", file):
        files.append(file)
    elif re.match(".*lz4", file):
        files.append(file)

file = max(files)
print(file)
    





