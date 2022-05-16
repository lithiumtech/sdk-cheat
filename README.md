# sdk-cheat
## Reduces typing to use services-sdk on command line

In your *`.zshrc`* file, you create an alias for this so you can run it from anywhere, changing the path to wherever you keep the `sdk-cheat` directory and `sdk.sh` file: 
`alias sdk='cd ~/dev/sdk-cheat; ./sdk.sh'`

## Usage

Once your alias is set up, you can use any of the following commands to run Services-SDK with the same result:

1. sdk khoros 99999
2. sdk khoros.stage 99999
3. kds khoros PSD-99999

```shell 
*//* cd /path/to/dir/khoros
      gulp -config="khoros.stage" --jira="PSD-99999"
      ```

The advantage of this is flexiblity to your preferences.

If you stop Services-SDK and use the sdk command by itself, without parameters, the script will ask if you want to use the last used parameters and give yo an example:

```shell
Did you want to use the previous configs, gulp --config="" --jira="" [y/n]? 
```

If you answer "y/Y" you the script will start Services-SDK just as if you had entered the paramters initially

If you answer "n/N" the script will walk you through the setup:
```shell
Enter sdk <site.phase or site> <PSD-xxxxx or xxxxxx> ?
```
And it will start as before
