addpath(genpath('../../NetworkGraphExpression'));
import matlab.unittest.TestSuite
suiteClass = TestSuite.fromClass(?NetworkGraphExpressionTest);
result = run(suiteClass);