/// Define scheduler resources associated with def operands.
def WriteIALU       : SchedWrite;    // 32 or 64-bit integer ALU operations
def WriteLDB        : SchedWrite;    // Load byte
def WriteLDH        : SchedWrite;    // Load half-word
def WriteLDW        : SchedWrite;    // Load word
def WriteSTB        : SchedWrite;    // Store byte
def WriteSTH        : SchedWrite;    // Store half-word
def WriteSTW        : SchedWrite;    // Store word
def WriteJmp        : SchedWrite;    // Jump
def WriteJal        : SchedWrite;    // Jump and link
def WriteJalr       : SchedWrite;    // Jump and link register


/// Define scheduler resource associated with use operands.
def ReadIALU        : SchedRead;
def ReadMemBase     : SchedRead;
def ReadStoreData   : SchedRead;
def ReadJmp         : SchedRead;
def ReadJalr        : SchedRead;
