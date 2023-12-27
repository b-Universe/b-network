# Unique space suit to Hydroxycobalamin (Iceccapade)
titanium_ice_space_suit_helmet:
  type: item
  debug: false
  material: chainmail_helmet
  display name: <&b>Titanium Ice Space Suit
  lore:
    - <empty>
    - <&7>Unique to<&co>
    - <&b>Hydroxycobalamin
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:titanium_ice
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 8
          slot: head

titanium_ice_space_suit_top:
  type: item
  debug: false
  material: chainmail_chestplate
  display name: <&b>Titanium Ice Space Suit
  lore:
    - <empty>
    - <&7>Unique to<&co>
    - <&b>Hydroxycobalamin
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:titanium_ice
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: chest

titanium_ice_space_suit_bottom:
  type: item
  debug: false
  material: chainmail_boots
  display name: <&b>Titanium Ice Space Suit
  lore:
    - <empty>
    - <&7>Unique to<&co>
    - <&b>Hydroxycobalamin
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:titanium_ice
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

# Unique space suit to Eutherine (Kadianye / Aedia)
# /ex flag server behr.essentials.uniques.47951ae6-aab4-4f72-a40f-fae9003e1785.space_suit:<map[helmet=toxoclast_exosuit_space_suit_helmet;chest=toxoclast_exosuit_space_suit_top;legs=toxoclast_exosuit_space_suit_bottom]>
toxoclast_exosuit_space_suit_helmet:
  type: item
  debug: false
  material: chainmail_helmet
  display name: <&b>Toxoclast Space Suit
  lore:
    - <empty>
    - <&7>Unique to<&co>
    - <&b>Kadianye
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:toxoclast_exosuit
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 8
          slot: head

toxoclast_exosuit_space_suit_top:
  type: item
  debug: false
  material: chainmail_chestplate
  display name: <&b>Toxoclast Space Suit
  lore:
    - <empty>
    - <&7>Unique to<&co>
    - <&b>Kadianye
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:toxoclast_exosuit
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: chest

toxoclast_exosuit_space_suit_bottom:
  type: item
  debug: false
  material: chainmail_boots
  display name: <&b>Toxoclast Space Suit
  lore:
    - <empty>
    - <&7>Unique to<&co>
    - <&b>Kadianye
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:toxoclast_exosuit
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet
