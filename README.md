HillClimb
=========

Hill climb search function template

A very general template for a hill climb algorithm. All you have to do is fill
in the methods #get_cost and #get_candidate_list and let the HillClimb do the
rest.

A nice feature of HillClimb is the selection of tests, which (hopefully)
verifies that the user has correctly subclassed it.

A quick TODO:

* Create a module of generally specific HillClimb tests that should also be
  valid for any subclasses. This is to help those who subclass HillClimb verify
  that they have subclassed it properly.