module contract.functions;


import contract;


// See #43
@Tags("contract")
@("functionproto.deref")
@safe unittest {

    const tu = parse(
        C(
            q{
                int binOp(int (f)(int x, int y), int a, int b);
            }
        )
    );

    tu.children.length.should == 1;

    const binOp = tu.child(0);
    binOp.shouldMatch(Cursor.Kind.FunctionDecl, "binOp");

    binOp.type.paramTypes.length.should == 3;
    const f = binOp.type.paramTypes[0];
    f.shouldMatch(Type.Kind.FunctionProto, "int (int, int)");
    writelnUt(f.pointee);
    // presumably, not a pointer
    f.pointee.isInvalid.should == true;
}


@Tags("contract")
@("functionproto.star")
@safe unittest {

    const tu = parse(
        C(
            q{
                int binOp(int (*f)(int x, int y), int a, int b);
            }
        )
    );

    tu.children.length.should == 1;

    const binOp = tu.child(0);
    binOp.shouldMatch(Cursor.Kind.FunctionDecl, "binOp");

    binOp.type.paramTypes.length.should == 3;
    const f = binOp.type.paramTypes[0];
    // Even though the declaration here is effectively the same as the
    // one in the test above, it shows up as a pointer
    f.shouldMatch(Type.Kind.Pointer, "int (*)(int, int)");
    writelnUt(f.pointee);
    // it's a pointer
    f.pointee.isInvalid.should == false;

    f.pointee.shouldMatch(Type.Kind.FunctionProto, "int (int, int)");
}
