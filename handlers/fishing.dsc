fishing_handler:
  type: world
  debug: false
  data:
    pufferfish:
      - allah
      - angel
      - angie
      - broken
      - business
      - capitalist
      - cnfused
      - cool
      - crab
      - cry
      - detective
      - excited
      - happ
      - jazz
      - long_pant
      - melting
      - monacle
      - monochrome
      - octo
      - party
      - poke
      - stonks
      - suit
      - surprised
      - su
      - thonk
      - tophat
      - trash
      - uwu
      - warden
      - potion
    eventful:
      valentines:
        - love
        - love2

      pride:
        - ace
        - bi
        - gay
        - lesbian
        - pan
        - trans

      halloween:
        - ghost
        - pumpkin
        - vampire
        - wizard
        - zombie

      christmas:
        - santa

  events:
    on player fishes pufferfish chance:20:
      - define pufferfish <script.data_key[data.pufferfish]>

      - if <util.random_chance[20]>:
        - if <util.time_now.month> == 2:
          - define pufferfish <[pufferfish].include[<script.data_key[data.eventful.valentines]>]>
        - else if <util.time_now.month> == 6:
          - define pufferfish <[pufferfish].include[<script.data_key[data.eventful.pride]>]>
        - else if <util.time_now.month> == 10:
          - define pufferfish <[pufferfish].include[<script.data_key[data.eventful.halloween]>]>
        - else if <util.time_now.month> == 12:
          - define pufferfish <[pufferfish].include[<script.data_key[data.eventful.christmas]>]>

      - determine puffer_<[pufferfish].random>

    on player consumes puffer_ace:
      - cast invisibility duration:8m
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s

    on player consumes puffer_bi:
      - cast night_vision duration:8m
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s

    on player consumes puffer_rainbow:
      - cast speed duration:8m
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s

    on player consumes puffer_lesbian:
      - cast increase_damage duration:8m
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s

    on player consumes puffer_pan:
      - cast luck duration:5m
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s

    on player consumes puffer_trans:
      - cast slow_falling duration:90s
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s

    on player potion effects added effect:poison|confusion|hunger flagged:behr.essentials.good_pufferfish_applied:
      - determine passively cancelled
      - wait 5t

    on player consumes puffer_allah|puffer_angie|puffer_melting:
      - explode <player.location>

    on player consumes puffer_angel|puffer_excited|puffer_happ|puffer_jazz|puffer_love|puffer_love_2:
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s
      - narrate targets:<player> "<&[green]>You were healed"

      - heal <player>

      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - repeat 100 as:i:
        - playeffect at:<player.location.add[<location[1,0,0].rotate_around_y[<[i].mul[183].to_radians>]>].above[<[i].div[40]>]> effect:villager_happy offset:0.05
        - if <[i].mod[10].equals[0]>:
          - wait 1t
          - playeffect effect:electric_spark at:<player.location.above> offset:0.5 quantity:10

    on player consumes puffer_party:
      - flag <player> behr.essentials.good_pufferfish_applied expire:1s
      - repeat 5:
        - random:
          - firework primary:random life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random trail life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random flicker life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random flicker trail life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random fade:random life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random fade:random trail life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random fade:random flicker life:1s <player.location.random_offset[1,0,1]>
          - firework primary:random fade:random flicker trail life:1s <player.location.random_offset[1,0,1]>
        - wait 10t

puffer_ace:
  type: item
  debug: false
  display name: <&f>Ace pufferfish
  material: pufferfish
  lore:
    - <&b>Pride month unique!
  mechanisms:
    custom_model_data: 1
puffer_allah:
  type: item
  debug: false
  display name: <&f>Allah Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 2

puffer_angel:
  type: item
  debug: false
  display name: <&f>Angel Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 3

puffer_angie:
  type: item
  debug: false
  display name: <&f>Angie Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 4

puffer_bi:
  type: item
  debug: false
  display name: <&f>Bi Pufferfish
  material: pufferfish
  lore:
    - <&b>Pride month unique!
  mechanisms:
    custom_model_data: 5

puffer_broken:
  type: item
  debug: false
  display name: <&f>Broken Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 6

puffer_business:
  type: item
  debug: false
  display name: <&f>Business Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 7

puffer_capitalist:
  type: item
  debug: false
  display name: <&f>Capitalist Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 8

puffer_confused:
  type: item
  debug: false
  display name: <&f>Confused Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 9

puffer_cool:
  type: item
  debug: false
  display name: <&f>Cool Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 10

puffer_crab:
  type: item
  debug: false
  display name: <&f>Crab Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 11

puffer_cry:
  type: item
  debug: false
  display name: <&f>Cry Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 12

puffer_detective:
  type: item
  debug: false
  display name: <&f>Detective Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 13

puffer_excited:
  type: item
  debug: false
  display name: <&f>Excited Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 14

puffer_ghost:
  type: item
  debug: false
  display name: <&f>Ghost Pufferfish
  material: pufferfish
  lore:
    - <&b>Halloween unique!
  mechanisms:
    custom_model_data: 15
puffer_happ:
  type: item
  debug: false
  display name: <&f>Happ Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 16
puffer_jazz:
  type: item
  debug: false
  display name: <&f>Jazz Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 17

puffer_lesbian:
  type: item
  debug: false
  display name: <&f>Lesbian Pufferfish
  material: pufferfish
  lore:
    - <&b>Pride month unique!
  mechanisms:
    custom_model_data: 18

puffer_long_pants:
  type: item
  debug: false
  display name: <&f>Long_pant Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 19

puffer_love:
  type: item
  debug: false
  display name: <&f>Love Pufferfish
  material: pufferfish
  lore:
    - <&b>Valentines unique!
  mechanisms:
    custom_model_data: 20

puffer_love_2:
  type: item
  debug: false
  display name: <&f>Lovey Pufferfish
  material: pufferfish
  lore:
    - <&b>Valentines unique!
  mechanisms:
    custom_model_data: 21

puffer_melting:
  type: item
  debug: false
  display name: <&f>Melting Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 22

puffer_monacle:
  type: item
  debug: false
  display name: <&f>Monacle Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 23

puffer_monochrome:
  type: item
  debug: false
  display name: <&f>Monochrom Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 24

puffer_octo:
  type: item
  debug: false
  display name: <&f>Octo Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 25

puffer_pan:
  type: item
  debug: false
  display name: <&f>Pan Pufferfish
  material: pufferfish
  lore:
    - <&b>Pride month unique!
  mechanisms:
    custom_model_data: 26

puffer_party:
  type: item
  debug: false
  display name: <&f>Party Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 27

puffer_poke:
  type: item
  debug: false
  display name: <&f>Poke Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 28

puffer_potion:
  type: item
  debug: false
  display name: <&f>Potion Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 29

puffer_pumpkin:
  type: item
  debug: false
  display name: <&f>Pumpkin Pufferfish
  material: pufferfish
  lore:
    - <&b>Halloween unique!
  mechanisms:
    custom_model_data: 30

puffer_rainbow:
  type: item
  debug: false
  display name: <&f>Rainbow Pufferfish
  material: pufferfish
  lore:
    - <&b>Pride month unique!
  mechanisms:
    custom_model_data: 31

puffer_santa:
  type: item
  debug: false
  display name: <&f>Santa Pufferfish
  material: pufferfish
  lore:
    - <&b>Christmas unique!
  mechanisms:
    custom_model_data: 32

puffer_stonks:
  type: item
  debug: false
  display name: <&f>Stonks Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 33

puffer_suit:
  type: item
  debug: false
  display name: <&f>Suit Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 34

puffer_surprised:
  type: item
  debug: false
  display name: <&f>Surprised Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 35

puffer_sus:
  type: item
  debug: false
  display name: <&f>Sus Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 36

puffer_thonk:
  type: item
  debug: false
  display name: <&f>Thonk Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 37

puffer_tophat:
  type: item
  debug: false
  display name: <&f>Tophat Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 38

puffer_trans:
  type: item
  debug: false
  display name: <&f>Trans Pufferfish
  material: pufferfish
  lore:
    - <&b>Pride month unique!
  mechanisms:
    custom_model_data: 39

puffer_trash:
  type: item
  debug: false
  display name: <&f>Trash Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 40

puffer_uwu:
  type: item
  debug: false
  display name: <&f>uwu Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 41

puffer_vampire:
  type: item
  debug: false
  display name: <&f>Vampire Pufferfish
  material: pufferfish
  lore:
    - <&b>Halloween unique!
  mechanisms:
    custom_model_data: 42

puffer_warden:
  type: item
  debug: false
  display name: <&f>Warden Pufferfish
  material: pufferfish
  mechanisms:
    custom_model_data: 43

puffer_wizard:
  type: item
  debug: false
  display name: <&f>Wizard Pufferfish
  material: pufferfish
  lore:
    - <&b>Halloween unique!
  mechanisms:
    custom_model_data: 44

puffer_zombie:
  type: item
  debug: false
  display name: <&f>Zombie Pufferfish
  material: pufferfish
  lore:
    - <&b>Halloween unique!
  mechanisms:
    custom_model_data: 45
