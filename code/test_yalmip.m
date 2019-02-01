clear; clc;

sdpvar x;
obj = -x;
constr0 = [ x <= 1];
optimize(constr0, obj)
value(x)

a = sdpvar(constr0);
sdpvar s;
constr1 = [a-s >= 0, s>=0] ;
optimize(constr1, obj)
value(x), value(a), value(s)


