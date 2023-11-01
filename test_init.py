# -*- coding: utf-8 -*-
# content of test_sample.py
def first_func_for_test(x):
    return x

def test_the_first_func():
    assert first_func_for_test(1) == 1
