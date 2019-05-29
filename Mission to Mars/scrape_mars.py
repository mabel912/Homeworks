#Dependencies
import os
import pandas as pd
import requests
import re
import time
from splinter import Browser
from bs4 import BeautifulSoup

# Initialize browser
def init_browser():
    # chromedriver executable path
    executable_path = {'executable_path': 'C:/Users/Mabel/Desktop/chromedriver.exe'}
    return Browser('chrome', **executable_path, headless=False)

# Create a Mars global dictionary that can be imported into Mongo

def scrape_all():
    mars_data = {}
    
    browser = init_browser()
    # URL of page to be scraped
    url = 'https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest'
    browser.visit(url)

    # Retrieve page with the requests module
    html = browser.html
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(html, 'html.parser')

    # Retrieve the most recent article title
    news_title = soup.find_all(class_="content_title")[0].text.strip()
    # Retrieve the most recent article title associated paragraph
    news_p = soup.find_all(class_="article_teaser_body")[0].text
    # Dictionary entry
    mars_data['news_title'] = news_title
    mars_data['news_paragraph'] = news_p

    # Mars Images
    url2="https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(url2)
    # Retrieve page with the requests module
    image_html = browser.html
    # Create BeautifulSoup object; parse with 'html.parser'
    image_soup = BeautifulSoup(image_html, 'html.parser')
    # Click the first page image button
    browser.click_link_by_partial_text('FULL IMAGE')
    time.sleep(2)
    # Click the following page more info button
    browser.click_link_by_partial_text('more info')
    time.sleep(2)
    # Retrieve page with the requests module
    image_html = browser.html
    # Create BeautifulSoup object; parse with 'html.parser'
    image_soup = BeautifulSoup(image_html, 'html.parser')
    # Assign a variable to the retrieved image
    image = image_soup.find("img", class_='main_image')["src"]
    # Concatenate the Image URl and display the full link
    featured_image_url = "https://www.jpl.nasa.gov" + image
    # Dictionary entry
    mars_data['featured_image_url'] = featured_image_url


    # Mars Weather
    url3 = "https://twitter.com/marswxreport?lang=en"
    browser.visit(url3)
    # Retrieve page with the requests module
    twitter_html = browser.html
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(twitter_html, 'html.parser')
    # Retrieve weather info
    mars_weather = soup.find_all("p", class_="TweetTextSize")[0].text.strip()
    # Dictionary entry
    mars_data['mars_weather'] = mars_weather
    

    # Mars Facts
    urlfacts = "https://space-facts.com/mars/"
    # Use Pandas to scrape the table containing facts about the planet
    facts = pd.read_html(urlfacts)
    # Look at the first table 
    tablefact = facts[0]
    # Change the name table column names
    tablefact.rename(columns={0: "Mars Planet Profile", 1: "Values"}, inplace=True)
    # Convert data table to a HTML table string
    tabledata = tablefact.to_html()
    # Dictionary entry
    mars_data['mars_facts'] = tabledata


    # Mars Hemispheres
    hemiURL = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(hemiURL)
    # Retrieve page with the requests module(HTML Object)
    hemi_html = browser.html
    # Create BeautifulSoup object; parse with 'html.parser'
    souphemi = BeautifulSoup(hemi_html, 'html.parser')

    # Retrieve the images
    # Store the main URL 
    hemi_main_url = 'https://astrogeology.usgs.gov'

    # Retrieve all items that contains mars hemispheres information
    imageitems = souphemi.find_all("div", class_="item")

    # Create empty list for urls
    hemisphere_image_urls = []

    for image in imageitems:

        title = image.find('h3').text
        partialurl = image.find('img', class_='thumb')['src']
        imageurl = hemi_main_url + partialurl
        hemisphere_image_urls.append({"title": title, "img_url": imageurl})
        # Dictionary entry
        mars_data['hemispheres'] = hemisphere_image_urls

    browser.quit()

    return mars_data