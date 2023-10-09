require('jester').setup{
  cmd = "node 'node_modules/.bin/jest' $file -t '$result'", -- run command
}
