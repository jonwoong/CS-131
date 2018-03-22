import java.util.concurrent.atomic.AtomicInteger;
import java.util.Arrays;

class BetterSorryState implements State {
    private AtomicInteger[] atomicArray;
    private byte maxval;

    ///// HELPER FUNCTIONS

    // convert byte[] to AtomicInteger[]
    private AtomicInteger[] byteToInt(byte[] byteArray) {
        AtomicInteger[] intArray = new AtomicInteger[byteArray.length];
        for (int i=0; i<byteArray.length; i++) {
            intArray[i] = new AtomicInteger(byteArray[i]);
        }
        return intArray;
    }

    // convert AtomicInteger[] to byte[]
    private byte[] intToByte(AtomicInteger[] intArray) {
        byte[] byteArray = new byte[intArray.length];
        for (int i=0; i<intArray.length; i++) {
            byteArray[i] = (byte)intArray[i].intValue();
        }
        return byteArray;
    }

    /////

    BetterSorryState(byte[] v) { 
        atomicArray = new AtomicInteger[v.length];
        atomicArray = Arrays.copyOf(byteToInt(v),v.length);
        maxval = 127; 
    }

    BetterSorryState(byte[] v, byte m) { 
        atomicArray = new AtomicInteger[v.length];
        atomicArray = Arrays.copyOf(byteToInt(v),v.length);
        maxval = m; 
    }

    public int size() { return atomicArray.length; }

    public byte[] current() { return intToByte(atomicArray); }

    public boolean swap(int i, int j) {
        if (atomicArray[i].get()<=0 || atomicArray[j].get()>=maxval) {
            return false;
        }
        atomicArray[i].getAndDecrement();
        atomicArray[j].getAndIncrement();
        return true;
    }

}
