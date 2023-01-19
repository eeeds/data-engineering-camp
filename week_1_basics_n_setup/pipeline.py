import pandas as pd
import sys 
print(sys.argv)
day = sys.argv[1]


df = pd.DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]})

print(f'Job finished sucessfully for day = {day}')