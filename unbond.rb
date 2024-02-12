#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

if ARGV.length != 1
  puts 'Usage: unbond.rb <nodeid>'
  exit 1
end

s = <<~NODES
  [
    {
      "node_id": 0,
      "private_key": "APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH",
      "address": "aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px"
    },
    {
      "node_id": 1,
      "private_key": "APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh",
      "address": "aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t"
    },
    {
      "node_id": 2,
      "private_key": "APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG",
      "address": "aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg"
    },
    {
      "node_id": 3,
      "private_key": "APrivateKey1zkpBjpEgLo4arVUkQmcLdKQMiAKGaHAQVVwmF8HQby8vdYs",
      "address": "aleo12ux3gdauck0v60westgcpqj7v8rrcr3v346e4jtq04q7kkt22czsh808v2"
    },
    {
      "node_id": 4,
      "private_key": "APrivateKey1zkp3J6rRrDEDKAMMzSQmkBqd3vPbjp4XTyH7oMKFn7eVFwf",
      "address": "aleo1p9sg8gapg22p3j42tang7c8kqzp4lhe6mg77gx32yys2a5y7pq9sxh6wrd"
    },
    {
      "node_id": 5,
      "private_key": "APrivateKey1zkp6w2DLUBBAGTHUK4JWqFjEHvqhTAWDB5Ex3XNGByFsWUh",
      "address": "aleo1l4z0j5cn5s6u6tpuqcj6anh30uaxkdfzatt9seap0atjcqk6nq9qnm9eqf"
    },
    {
      "node_id": 6,
      "private_key": "APrivateKey1zkpEBzoLNhxVp6nMPoCHGRPudASsbCScHCGDe6waPRm87V1",
      "address": "aleo1aukf3jeec42ssttmq964udw0efyzt77hc4ne93upsu2plgz0muqsg62t68"
    },
    {
      "node_id": 7,
      "private_key": "APrivateKey1zkpBZ9vQGe1VtpSXnhyrzp9XxMfKtY3cPopFC9ZB6EYFays",
      "address": "aleo1y4s2sjw03lkg3htlcpg683ec2j9waprljc657tfu4wl6sd67juqqvrg04a"
    },
    {
      "node_id": 8,
      "private_key": "APrivateKey1zkpHqcqMzArwGX3to2x1bDVFDxo7uEWL4FGVKnstphnybZq",
      "address": "aleo1xh2lnryvtzxcvlz8zzgranu6yldaq5257cac44de4v0aasgu45yq3yk3yv"
    },
    {
      "node_id": 9,
      "private_key": "APrivateKey1zkp6QYrYZGxnDmwvQSg7Nw6Ye6WUeXHvs3wtj5Xa9LArc7p",
      "address": "aleo19ljgqpwy98l9sz4f6ly028rl8j8r4grlnetp9e2nwt2xwyfawuxq5yd0tj"
    },
    {
      "node_id": 10,
      "private_key": "APrivateKey1zkp9AZwPkk4gYUCRtkaX5ZSfBymToB7azBJHmJkSvfyfcn4",
      "address": "aleo1s2tyzgqr9p95sxtj9t0s38cmz9pa26edxp4nv0s8mk3tmdzmqgzsctqhxg"
    },
    {
      "node_id": 11,
      "private_key": "APrivateKey1zkp2jCDeE8bPnKXKDrXcKaGQRVfoZ1WFUiVorbTwDrEv6Cg",
      "address": "aleo1sufp275hshd7srrkxwdf7yczmc89em6e5ly933ftnaz64jlq8qysnuz88d"
    },
    {
      "node_id": 12,
      "private_key": "APrivateKey1zkp7St3ztS3cag91PpyQbBffTc8YLmigCGB97Sf6bkQwvpg",
      "address": "aleo1mwcjkpm5hpqapnsyddnwtmd873lz2kpp6uqayyuvstr4ky2ycv9sglne5m"
    },
    {
      "node_id": 13,
      "private_key": "APrivateKey1zkpGcGacddZtDLRc8RM4cZb6cm3GoUwpJjSCQcf2mfeY6Do",
      "address": "aleo1khukq9nkx5mq3eqfm5p68g4855ewqwg7mk0rn6ysfru73krvfg8qfvc4dt"
    },
    {
      "node_id": 14,
      "private_key": "APrivateKey1zkp4ZXEtPR4VY7vjkCihYcSZxAn68qhr6gTdw8br95vvPFe",
      "address": "aleo1masuagxaduf9ne0xqvct06gpf2tmmxzcgq5w2el3allhu9dsv5pskk7wvm"
    },
    {
      "node_id": 15,
      "private_key": "APrivateKey1zkpH7XEPZDUrEBnMtq1JyCR6ipwjFQ5jiHnTCe7Z7heyxff",
      "address": "aleo10w89dpq8tqzeghq35nxtk2k66pskxm8vhrdl3vx6r4j9hkgf2qqs3936q6"
    },
    {
      "node_id": 16,
      "private_key": "APrivateKey1zkpA9S3Epe8mzDnMuAXBmdxyRXgB8yp7PuMrs2teh8xNcVe",
      "address": "aleo1sfu3p7g8rppusft8re7v88ujjhz5sx6pwc5609vdgnr0pdmhkyyqrrsjkm"
    },
    {
      "node_id": 17,
      "private_key": "APrivateKey1zkp5neB5iVnXMTrR6y8P6wndGE9xWhQzBf3Qoht9yQ17a5o",
      "address": "aleo1ry0wc384qthrdna5xtzsjqvxg42zwfezpna6keeqa6netv3qmyxszhh8z8"
    },
    {
      "node_id": 18,
      "private_key": "APrivateKey1zkp4u1cUbvkC2r3n3Gz3eNzth1TvffGbFeLgaYyk8efsT4e",
      "address": "aleo1ps4dhhfn5vgfj9lyjra2xnv9a8cc2a2l9jnr585h6tvj4gnlqgfqyszcv3"
    },
    {
      "node_id": 19,
      "private_key": "APrivateKey1zkpBs9zc9FChKZAkoHsf1TERcd9EQhe43NS1xuNSnyJSH1K",
      "address": "aleo15a34a3dtpj879frvndndp0605vqnxsfdedwyrtu5u6xfd7fv5ufqryavc4"
    },
    {
      "node_id": 20,
      "private_key": "APrivateKey1zkp3sh4dSfCXd9g86DGHx6PAQG7WrMxE8bMbJxCrpPKSUw3",
      "address": "aleo1mpn4enrfm2dqjg8lqh09t2zcatkujq3qr3kq8kcnrd7uaqrc3c9qngcp5l"
    },
    {
      "node_id": 21,
      "private_key": "APrivateKey1zkpApK3vKdDDwbf62K5Mh7JsPNksud3ypZEXvuoYPcazStS",
      "address": "aleo1axy39ux5lhaypf039zp7fuhg57qkfqtafu2fa3e2vwgqugeq05qsm2kfl4"
    },
    {
      "node_id": 22,
      "private_key": "APrivateKey1zkp2uS6cU4M4J8z2fE3uMuQHkg87AgrMnDQ8NZzGAnpiEXm",
      "address": "aleo1zzpl369camggvj5qm2nhnpfhe3epcera3xvdra4ze7scg35zmuzsl7kwyh"
    },
    {
      "node_id": 23,
      "private_key": "APrivateKey1zkp8za2Nc39VHQFzBQFH6rhKuB9LqPaoVw1SgUPG8pSGAAn",
      "address": "aleo1j2fhcu3qkvn4k0vrf53jmuv8d0fz5guz9tzdy0egjjjttdhsxszqfdfwfk"
    },
    {
      "node_id": 24,
      "private_key": "APrivateKey1zkp4JjfHAVD9d6S9n8FYpVnapkJ3yfiyPaQNnAqsuexUQcU",
      "address": "aleo1jqfyapkxkx3hk05mjzky9cqxjr5yz33fwfqujpd0uy5zxxwfkvqskcffhq"
    },
    {
      "node_id": 25,
      "private_key": "APrivateKey1zkpFT2mMYvZ7TPzjkCGH5F64itzRBwjscqqqezx6AaPnqxF",
      "address": "aleo1sap6x2ndmmwm8t6z568hc33u8ayynw2ha9u9pck7wvrrd0e7k58sty954x"
    },
    {
      "node_id": 26,
      "private_key": "APrivateKey1zkpJcSh3d66dxtTvaA1b9P9xAdUXMKnWsQSkhmZRDpEUJYr",
      "address": "aleo19afl0wwru8ws7g7c727j27x0e8r7sa5gkjz6jv37sr4ujlm5sqzs2qt8wz"
    },
    {
      "node_id": 27,
      "private_key": "APrivateKey1zkpAy7c3uea5yuvjkuN9eqGSoBJDHpE33yCe5qu7u2JbVmZ",
      "address": "aleo1ypkmme72un8k4dzaj0z6ha2skz9adskscwf75eul27j5e7lu6s9q0pu9qx"
    },
    {
      "node_id": 28,
      "private_key": "APrivateKey1zkp3GUSi7FQW7FgLyPp77A45CvDjZFwdqgWzLzkxbB3GXKD",
      "address": "aleo1av8367kf2dre7mwpuyhcg7wrhtvs27usa53fn8uwmd5x7r2gsyrs9084ge"
    },
    {
      "node_id": 29,
      "private_key": "APrivateKey1zkp5rtsaS8tZwZVrf5PwQwnfvcm7Q4UntrcXXiwYTMRuz9T",
      "address": "aleo1y7swdgs3zav50a0r0sx8us4tqycp67kc9ypnml5eqjfpypk7cgqszf6dvn"
    },
    {
      "node_id": 30,
      "private_key": "APrivateKey1zkpDPHco2BZh95YCD2eZc44LZ8YfuZq85qfULBVgUB6SouE",
      "address": "aleo16dyj3gxptzm5vgfyxlv2s6869ftfdxwpl2hm9r09uqk69kcjwvfqqpu2pm"
    },
    {
      "node_id": 31,
      "private_key": "APrivateKey1zkp2jaPbqqFLXiTr92CSDEqevwzaVsj4MbC43apRKFXnWSd",
      "address": "aleo1ftv0e670e2nezrdajxg947vn3el4cgjt47nghleuw5a7dja9dyrszr5jhp"
    },
    {
      "node_id": 32,
      "private_key": "APrivateKey1zkpEycEZpddReHV4UExGpWSQZUCau2g6K2HP1jQnCSPUAL9",
      "address": "aleo1d7wfgrgtk75g8m08d7f8jmyk6f8kg9w8jpm7l97hyx0kf6l8asrsdnhzzz"
    },
    {
      "node_id": 33,
      "private_key": "APrivateKey1zkp9gJgMLBiVKVRSSqbRDQFcKm84sQbJF9wqWzcSnXVw1we",
      "address": "aleo1hcaq72hw8tf7ms4qfppefklwdr32ud3nngu88wnx6dq67dzgl58scpsg8v"
    },
    {
      "node_id": 34,
      "private_key": "APrivateKey1zkp7jX54qsuFZ5Ks2DJhPzx6io2EM2CZhTYA3XU2XfXt2rr",
      "address": "aleo1szkl7zn07mgd44qpg43wk3sd5emggc3w5frd3wwms9c4rwklygzs7mn4x9"
    },
    {
      "node_id": 35,
      "private_key": "APrivateKey1zkpDyVQ7mGpb48oS44Zee1gPvA19ng98S2MRCCCcsh7Av8r",
      "address": "aleo1sekqksjqnmhpyca5juxxghrujck8dm9lrhp70nrsp9a7hd4sxczswyrnjj"
    },
    {
      "node_id": 36,
      "private_key": "APrivateKey1zkp5grVqsMuASdVowmgsK5CCBjz9dAqAw2K1szc4jPC15EN",
      "address": "aleo18y86x2qvjsg0tay6fj9cjqejhvv45wnd53a66tax6j3zrxu9gupsh7e86v"
    },
    {
      "node_id": 37,
      "private_key": "APrivateKey1zkp5s39kX98KZmm4vdfhHuWhMbP5mVCREFRZuT9GGduzb6x",
      "address": "aleo1rnhvu0f4m6ymwegyemqyt7hfsqqaqxpn29l7jafvyuw60nz9ygysu0jn23"
    },
    {
      "node_id": 38,
      "private_key": "APrivateKey1zkp642Mn8JgLFC4C5JGdy73VMg5skFoAj5dmaxKs2zTnDbN",
      "address": "aleo192e2mn3lmav8csm0krjn0va5v9nur6pr03y8vepe09xc5qummvxq338czu"
    },
    {
      "node_id": 39,
      "private_key": "APrivateKey1zkpFisano5hmJvALiVkgVcxVRL61aS8jz2CwFeAQQS9j6Qu",
      "address": "aleo1mjwjwe67rzs7w08psynya7pc3q4shpyggz92xksy4rumfzfmdc9qnrk4pl"
    },
    {
      "node_id": 40,
      "private_key": "APrivateKey1zkp6gB8LRzRs1chkWMnk7ffAytADkdZEDxggqEEAdV1qQBC",
      "address": "aleo1ffdnchytga8nuzg557h8cx0h89xlddxhucxdphtg8k8v8tn7zuysxa893d"
    },
    {
      "node_id": 41,
      "private_key": "APrivateKey1zkp7mXyitjWX5hXUznSKpfEMUqdMVzCwG728Nzf1R1axRzL",
      "address": "aleo16w6zw8glrj08psy5nwumsed7kmxwxk8paq2d92m7dk2uerwzuqqsvkamnk"
    },
    {
      "node_id": 42,
      "private_key": "APrivateKey1zkp6WadY8WbPq2or8YMJDFyS9c6HHyoJEif567i4SqVv2h8",
      "address": "aleo1dfystswcj4j0k8nckast6ylexrwuhv42ysldx7x03q0uch259ypsfml8h7"
    },
    {
      "node_id": 43,
      "private_key": "APrivateKey1zkpJMcEf79UR7n2W5rzLrkeg1hTrWHQyNJcvKmhsJWkzTsN",
      "address": "aleo1j97mw86ytd6v6zl76qju6dm9ee3t0zjdsaydph7dtweusm6vavqsmswgzg"
    },
    {
      "node_id": 44,
      "private_key": "APrivateKey1zkpEe33jVdjakXiQcKfJUf9fyVaTMxHJcuipXmAWgy55TFQ",
      "address": "aleo17g5m4scr8x8yndx6spsmnu5wk45sgwe4w2la8gnxu0zjn7cfssxq2sxsef"
    },
    {
      "node_id": 45,
      "private_key": "APrivateKey1zkpGTtLxB3mUbew6mkP3D7tqVveVEZYYKmgVun1CyXJcXmF",
      "address": "aleo1hkuf3ypfym59m23c8jmw97yxpldsk2ycc9rc2x0eaaxd9x6fmvqqpfg08d"
    },
    {
      "node_id": 46,
      "private_key": "APrivateKey1zkp7aPCqYDux1n8DdLGPFNqkoHjSjpkoSaiVpKcf4Xpgz3B",
      "address": "aleo1e9xrl7ummq63d6zay60w5klqkfhya5kwcwa757hqzgujkk9ddcgqnufluq"
    },
    {
      "node_id": 47,
      "private_key": "APrivateKey1zkpDbTD13qeLjMA6ympzFFo1Z2mnUHg8DRAaSKE7qCWW79f",
      "address": "aleo1u44retdlrhptya55qgxly0um6ydajrz2mhthxtyukzekctxtag9sdcy0cm"
    },
    {
      "node_id": 48,
      "private_key": "APrivateKey1zkpBfe9853NcMnagBeYpimPrT5ZN8fYi8aMv45rxkxbm7Gn",
      "address": "aleo1wqcgpvt58d03nl34vhx3kc0v4jh04f6alvt5s38q3jhdq3shqcxq6g5v70"
    },
    {
      "node_id": 49,
      "private_key": "APrivateKey1zkpG22T5KZGDE54HmVCp91vhzNrzb7HihynmUyZ4DX9Ngj2",
      "address": "aleo1s77df89g2km8urqvanvthhuxyw9d32plmjvewthm7cjhnezxtygq78mrd"
    }
  ]
NODES

n = JSON.parse(s)

ID = ARGV[0].to_i

def wait_height(height)
  puts "waiting for block height #{height}"
  uri = URI('http://0.0.0.0:3030/mainnet/latest/height')
  loop do
    begin
      response = Net::HTTP.get(uri)
      puts "current block height #{response}"
      break if response.to_i >= height
    rescue StandardError
      nil
    end
    sleep 60
  end
  puts "block height #{height} reached"
end

def get_unbond_height(address)
  uri = URI("http://0.0.0.0:3030/mainnet/program/credits.aleo/mapping/unbonding/#{address}")
  response = Net::HTTP.get(uri)
  # what is returned is not valid JSON: it doesn't have quotes around the keys
  response.sub(/.*height: ([^u]*)u32.*/m, '\1').to_i
end

def wait_unbond(num, address)
  puts "waiting for node #{num} to be unbonded #{address}"
  uri = URI("http://0.0.0.0:3030/mainnet/program/credits.aleo/mapping/committee/#{address}")
  loop do
    begin
      response = Net::HTTP.get(uri)
      break if response == 'null'
    rescue StandardError
      nil
    end
    sleep 10
  end
  puts "node #{num} is unbonded #{address}"
end

def unbond(num, priv, address)
  bond = 'cargo run -- developer execute credits.aleo unbond_public 1000000000000u64 ' \
         "--private-key #{priv} --query http://0.0.0.0:3030 " \
         '--broadcast http://0.0.0.0:3030/mainnet/transaction/broadcast'
  puts "unbonding node #{num}"
  system bond, out: File::NULL, err: File::NULL
  wait_unbond(num, address)
end

def claim(num, priv)
  bond = 'cargo run -- developer execute credits.aleo claim_unbond_public ' \
         "--private-key #{priv} --query http://0.0.0.0:3030 " \
         '--broadcast http://0.0.0.0:3030/mainnet/transaction/broadcast'
  puts "claim unbonding node #{num}"
  system bond # , out: File::NULL, err: File::NULL
  puts "node #{num} is fully unbonded"
end

# main code starts here
address = n[ID]['address']
priv = n[ID]['private_key']
unbond(ID, priv, address)
height = get_unbond_height(address)
wait_height(height)
claim(ID, priv)
