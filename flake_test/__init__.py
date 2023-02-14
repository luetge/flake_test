import numpy as np
import h5py

def __main__():
    d = np.zeros(shape=(3, 2))
    with h5py.File("/tmp/test.h5", "w") as f:
        f["test"] = d
    print(d)
    print("Done!")

if __name__ == "__main__":
    __main__()
