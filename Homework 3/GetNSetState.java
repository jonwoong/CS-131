import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State {

    private int maxvalInt;
    private AtomicIntegerArray atomicArray;

    ///// HELPER FUNCTIONS

    // convert byte[] to AtomicIntegerArray
    private int[] byteToInt(byte[] byteArray) {
        int[] intArray = new int[byteArray.length];

        for (int i=0; i<byteArray.length; i++) 
            intArray[i] = (byteArray[i] & 0xff);

        return intArray;
    }

    // convert AtomicIntegerArray to byte[]
    private byte[] intToByte(AtomicIntegerArray intArray) {
        byte[] byteArray = new byte[intArray.length()];

        for (int i=0; i<intArray.length(); i++)
            byteArray[i] = (byte)intArray.get(i);

        return byteArray;
    }

    /////

    GetNSetState(byte[] v) { 
        atomicArray = new AtomicIntegerArray(byteToInt(v)); 
        maxvalInt = 127;
    }

    GetNSetState(byte[] v, byte m) {
        atomicArray = new AtomicIntegerArray(byteToInt(v));  
        maxvalInt = (m & 0xff); // convert byte to int
    }

    public int size() { return atomicArray.length(); }

    public byte[] current() { return intToByte(atomicArray); }

    public boolean swap(int i, int j) {
    	if (atomicArray.get(i) <= 0 || atomicArray.get(j) >= maxvalInt) {
    	    return false;
    	}
    	atomicArray.set(i,atomicArray.get(i)-1);
    	atomicArray.set(j,atomicArray.get(j)+1);
    	return true;
        }
}
