# How the Script Works

First, set the working directory. This is where everything will happen.

Next, load the packages. In this case, we are only loading data.table and reshape2.

Download the dataset using the given url. I am on a Mac, so this means I need to add "method=curl" to my download.file function . Once that is done, the file gets unzipped with the "unzip" function. That unzipped folder is then set as the input path so we can read all the files in it next. 

Read the subject files, the activity files, and the data files. Each of these contains a training and a test set, and we need to merge those using rbind. This sort of stacks one on top of the other. 

Binding by columns, the script then merges subjects with their activities. Setting the key sorts by subject first, then on the activity number. 

The script then extracts the mean and the standard deviation. Once this is done, it gives useful names to the columns like activity names and activity number. The activity name is set as a key. 

Once all the feature names are set, the data set is tidied up and exported in .txt format.







