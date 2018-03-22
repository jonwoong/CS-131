import java.util.concurrent.locks.ReentrantLock;

class BetterSafeState implements State {
    private byte[] value;
    private byte maxval;

    private final ReentrantLock rLock = new ReentrantLock();

    BetterSafeState(byte[] v) { value = v; maxval = 127; }

    BetterSafeState(byte[] v, byte m) { value = v; maxval = m; }

    public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
        if (value[i] <= 0 || value[j] >= maxval) {
                return false;
            }
        rLock.lock(); // get lock
        try {
        	value[i]--;
        	value[j]++;
        } finally {
        	rLock.unlock(); // unlock
            return true; 
        }
    }
        
}
