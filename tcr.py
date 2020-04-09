from hamcrest import assert_that, equal_to, is_in, contains_string

my_bool = True
assert_that(True, equal_to(True))
assert_that(True, is_in([True, False]))
assert_that("lol", contains_string("lol"))
print("My bool is " + str(my_bool))
assert my_bool
assert 2+2 == 4
assert 2+3 == 5
assert 2+3 == abs(-5)
assert "LOL"
assert not ""
my_list = list()
assert not my_list
my_list.append(1)
assert my_list
assert -1
assert 1+1
assert True
