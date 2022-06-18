use Dotenv; 
Dotenv->load;

my ($action, $arg1, $arg2) = @ARGV;

for ($action) {
    # containers.
    if (/^up$/)        { exec("docker compose up -d && docker compose ps");            }
    if (/^app$/)       { exec("docker compose exec app sh");                           }
    if (/^down$/)      { exec("docker compose down -t 5");                             }
    if (/^logs$/)      { exec("docker compose logs -f");                               }
    if (/^carmel$/)    { exec("docker compose exec app carmel $arg1 $arg2 --verbose"); }
    if (/^attach$/)    { exec("docker compose exec $arg1 sh");                         }
    if (/^restart$/)   { exec("docker compose restart && docker compose ps");          }

    # npm
    if (/^npm-watch$/)   { exec("docker compose run --rm npm npm run watch"); }
    if (/^npm-build$/)   { exec("docker compose run --rm npm npm run build"); }
    if (/^npm-install$/) { exec("docker compose run --rm npm npm install");   }

    # db.
    if (/^db$/)           { exec("docker compose exec db mysql -u$ENV{MYSQL_USER} -p$ENV{MYSQL_PASSWORD}");                            }
    if (/^db-migration$/) { exec("docker compose exec app carmel exec bin/migration.pl $arg1");                                        }
}

print "Action not found\n";

__END__
