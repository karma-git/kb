"""python recursive folder read
ref: https://stackoverflow.com/questions/2212643/python-recursive-folder-read
"""
import os


def main(abs_path: str):
  """
  find ${abs_path} -type f
  """
  for currentpath, folders, files in os.walk(abs_path):
    for file in files:
        print(os.path.join(currentpath, file))

if __name__ == "__main__":
    main(abs_path='/home/jhon')
