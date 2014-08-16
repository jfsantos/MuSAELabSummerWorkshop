# -*- coding: utf-8 -*-
"""
Stupid and unnecessary function to increment items in lists.

Created on Fri Aug 15 11:48:00 2014

@author: jfsantos
"""

def increment_items(mylist):
    for el in mylist: # fix: use enumerate to mutate in place
        el += 1

def test_increment_items():
    testlist = range(5)
    increment_items(testlist)
    assert testlist == range(1,6)
