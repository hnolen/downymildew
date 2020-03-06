# downymildew

This repo contains any downy mildew-related scripts (phylogenetics, pop gen, etc..)

# Python Club - Mar 2 2020

Created By: Haley Nolen
Last Edited: Mar 02, 2020 3:07 PM

## Sending emails without going to junk

reduce amount of links or do no links

can use `local host` to use the server you're on to send email

    module load smtplib
    from email.utils import make_msgid #function 
    from email.mime.text import MIMEText
    body = "....."
    message = MIMEText(body, "text") #MIMEText is a class - making an instance of the MIMEText class
    message["subject"] = "subject of email"
    message["from"] = "Name <email address>" #spam filters look for these 
    message["to"] = ...
    message["message-ID"] = make_msgid() #generates a random string to go in this field
    
    # all of this will probably get your email through but if not it might be because you need to
    # use a more well known server - can do through smtplib

when computer looks at "jane@[robot.com](http://robot.com)" checks to see if robot.com exists (host → IP address by DNS)

- Ron and premise do not have this DNS and makes it look sketch

## Practice problem

When you take in an instance of this class you're going to create a grid, input your position, and put in locations where there are walls, target location, outputs shortest path from you to target location

outer edge or wall - #

initial location - &

target location - x

everything else - . 

    #! /usr/bin/env python3
    class Pathfinder:
        def __init__(self, x, y, start, target):
    		    self.x = x
    		    self.y = y
    		    self.start = start
    		    self.target = target
            self.grid = self.make_grid()
        # we want this to be unique for each instance, so we can have multiple grids, needs to be an instance attribute
        def make_grid(self):
        grid = []
        for row in range(self.y):
            grid.append([])
            for col in range(self.x):
                grid[row].append("") #going to end up putting a string in here, so make it a string
        return grid          
      
                    
                

Remember - class methods cannot access instance attributes - so `draw_grid()` needs access to instance attributes so it must be an instance method

If we make our grid as a list of lists we can index grid
