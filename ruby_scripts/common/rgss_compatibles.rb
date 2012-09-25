# -*- coding: utf-8 -*-
module Conkool
  class RgssCompatible
    # クラスインスタンス変数/メソッドの定義
    class << self
      attr_accessor :compatible_class
      attr_accessor :accessors
      
      def accessors
        @accessors ||=[]
        # 基底クラスでなければ、親をさかのぼってアクセサを追加する。
        if self != RgssCompatible
          return @accessors.concat(self.superclass.accessors)
        else
          return @accessors
        end
      end
    end
    
    # 指定されたシンボルでアクセサを作る。
    def self.create_accessors(*args)
      self.accessors = args
      self.accessors.each { |acs| attr_accessor acs }
    end
    
    module Xp; end
    module Vx; end
    module Vxace; end
  end

  # RPG::Map Compatible
  class RgssCompatible::Vxace::Map < RgssCompatible
    create_accessors :display_name, :tileset_id, :width, :height, :scroll_type, :specify_battleback, :battleback1_name, :battleback2_name, :autoplay_bgm, :bgm, :autoplay_bgs, :bgs,:disable_dashing, :encounter_list, :encounter_step, :parallax_name, :parallax_loop_x, :parallax_loop_y, :parallax_sx, :parallax_sy, :parallax_show, :note, :data, :events
  end

  # RPG::Map::Encounter Compatible
  class  RgssCompatible::Vxace::Map::Encounter < RgssCompatible
    create_accessors :troop_id, :weight, :region_set
  end
  
  # RPG::MapInfo Compatible
  class  RgssCompatible::Vxace::MapInfo < RgssCompatible
    create_accessors :name, :parent_id, :order ,:expanded, :scroll_x, :scroll_y
  end
  
  # RPG::Event Compatible
  class RgssCompatible::Vxace::Event < RgssCompatible
    create_accessors :id, :name, :x, :y, :pages
  end
  
  # RPG::Event::Page Compatible
  class RgssCompatible::Vxace::Event::Page < RgssCompatible
    create_accessors :condition,:graphic,:move_type, :move_speed, :move_frequency, :move_route,:walk_anime, :step_anime,:direction_fix,:through,:priority_type,:trigger,:list
  end

  # RPG::Event::Page::Condition Compatible
  class RgssCompatible::Vxace::Event::Page::Condition < RgssCompatible
    create_accessors :switch1_valid, :switch2_valid,:variable_valid,:self_switch_valid,:item_valid,:actor_valid,:switch1_id, :switch2_id,:variable_id, :variable_value,:self_switch_ch,:item_id,:actor_id
  end

  # RPG::Event::Page::Graphic Compatible
  class RgssCompatible::Vxace::Event::Page::Graphic < RgssCompatible
    create_accessors :tile_id, :character_name, :character_index, :direction, :pattern
  end

  # RPG::EventCommand Compatible
  class RgssCompatible::Vxace::EventCommand < RgssCompatible
    create_accessors :code, :indent, :parameters
  end

  # RPG::MoveRoute Compatible
  class RgssCompatible::Vxace::MoveRoute < RgssCompatible
    create_accessors :repeat, :skippable, :wait, :list
  end

  # RPG::MoveCommand Compatible
  class RgssCompatible::Vxace::MoveCommand < RgssCompatible
    create_accessors :code, :parameters
  end

  # RPG::BaseItem Compatible
  class RgssCompatible::Vxace::BaseItem < RgssCompatible
    create_accessors :id, :name, :icon_index, :description, :features, :note
  end

  # RPG::Actor Compatible
  class RgssCompatible::Vxace::Actor < RgssCompatible::Vxace::BaseItem
    create_accessors :nickname, :class_id, :initial_level, :max_level, :character_name, :character_index, :face_name, :face_index, :equips
  end

  # RPG::Class Compatible
  class RgssCompatible::Vxace::Class < RgssCompatible::Vxace::BaseItem
    create_accessors :exp_params, :params, :learnings
  end

  # RPG::Class::Learning Compatible
  class RgssCompatible::Vxace::Class::Learning < RgssCompatible
    create_accessors :level, :skill_id, :note
  end

  # RPG::UsableItem Compatible
  class RgssCompatible::Vxace::UsableItem < RgssCompatible::Vxace::BaseItem
    create_accessors :scope, :occasion, :speed, :animation_id, :success_rate, :repeats, :tp_gain, :hit_type, :damage, :effects
  end

  # RPG::Skill Compatible
  class RgssCompatible::Vxace::Skill < RgssCompatible::Vxace::UsableItem
    create_accessors :stype_id, :mp_cost, :tp_cost, :message1, :message2,:required_wtype_id1, :required_wtype_id2
  end

  # RPG::Item Compatible
  class RgssCompatible::Vxace::Item < RgssCompatible::Vxace::UsableItem
    create_accessors :itype_id, :price, :consumable
  end

  # RPG::EquipItem Compatible
  class RgssCompatible::Vxace::EquipItem < RgssCompatible::Vxace::BaseItem
    create_accessors :price, :etype_id, :params
  end

  # RPG::Weapon Compatible
  class RgssCompatible::Vxace::Weapon < RgssCompatible::Vxace::EquipItem
    create_accessors :wtype_id, :animation_id
  end

  # RPG::Armor Compatible
  class RgssCompatible::Vxace::Armor < RgssCompatible::Vxace::EquipItem
    create_accessors :atype_id
  end

  # RPG::Enemy Compatible
  class RgssCompatible::Vxace::Enemy < RgssCompatible::Vxace::BaseItem
    create_accessors :battler_name, :battler_hue, :params, :exp, :gold, :drop_items, :actions
  end

  # RPG::State Compatible
  class RgssCompatible::Vxace::State < RgssCompatible::Vxace::BaseItem
    create_accessors :restriction, :priority, :remove_at_battle_end, :remove_by_restriction, :auto_removal_timing, :min_turns, :max_turns, :remove_by_damage, :chance_by_damage, :remove_by_walking, :steps_to_remove, :message1, :message2, :message3, :message4
  end

  # RPG::BaseItem::Feature Compatible
  class RgssCompatible::Vxace::BaseItem::Feature < RgssCompatible
    create_accessors :code, :data_id, :value
  end

  # RPG::UsableItem::Damage Compatible
  class RgssCompatible::Vxace::UsableItem::Damage < RgssCompatible
    create_accessors :type, :element_id, :formula, :variance, :critical
  end

  # RPG::UsableItem::Effect Compatible
  class RgssCompatible::Vxace::UsableItem::Effect < RgssCompatible
    create_accessors :code, :data_id, :value1, :value2
  end

  # RPG::Enemy::DropItem Compatible
  class RgssCompatible::Vxace::Enemy::DropItem < RgssCompatible
    create_accessors :kind, :data_id, :denominator
  end

  # RPG::Enemy::Action Compatible
  class RgssCompatible::Vxace::Enemy::Action < RgssCompatible
    create_accessors :skill_id, :condition_type, :condition_param1, :condition_param2, :rating
  end

  # RPG::Troop Compatible
  class RgssCompatible::Vxace::Troop < RgssCompatible
    create_accessors :id, :name, :members, :pages
  end

  # RPG::Troop::Member Compatible
  class RgssCompatible::Vxace::Troop::Member < RgssCompatible
    create_accessors :enemy_id, :x, :y, :hidden
  end

  # RPG::Troop::Page Compatible
  class RgssCompatible::Vxace::Troop::Page < RgssCompatible
    create_accessors :condition, :span, :list
  end

  # RPG::Troop::Page::Condition Compatible
  class RgssCompatible::Vxace::Troop::Page::Condition < RgssCompatible
    create_accessors :turn_ending, :turn_valid, :enemy_valid, :actor_valid, :switch_valid, :turn_a, :turn_b, :enemy_index, :enemy_hp, :actor_id, :actor_hp, :switch_id
  end

  # RPG::Animation Compatible
  class RgssCompatible::Vxace::Animation < RgssCompatible
    create_accessors :id, :name, :animation1_name, :animation1_hue, :animation2_name, :animation2_hue, :position, :frame_max, :frames, :timings
  end

  # RPG::Animation::Frame Compatible
  class RgssCompatible::Vxace::Animation::Frame < RgssCompatible
    create_accessors :cell_max, :cell_data
  end

  # RPG::Animation::Timing Compatible
  class RgssCompatible::Vxace::Animation::Timing < RgssCompatible
    create_accessors :frame, :se, :flash_scope, :flash_color, :flash_duration
  end

  # RPG::Tileset Compatible
  class RgssCompatible::Vxace::Tileset < RgssCompatible
    create_accessors :id, :mode, :name, :tileset_names, :flags, :note
  end

  # RPG::CommonEvent Compatible
  class RgssCompatible::Vxace::CommonEvent < RgssCompatible
    create_accessors :id, :name, :trigger, :switch_id, :list
  end

  # RPG::System Compatible
  class RgssCompatible::Vxace::System < RgssCompatible
    create_accessors :game_title, :version_id, :japanese, :party_members, :currency_unit, :skill_types, :weapon_types, :armor_types, :elements, :switches, :variables, :boat, :ship, :airship, :title1_name, :title2_name, :opt_draw_title, :opt_use_midi, :opt_transparent, :opt_followers, :opt_slip_death, :opt_floor_death, :opt_display_tp, :opt_extra_exp, :window_tone, :title_bgm, :battle_bgm, :battle_end_me, :gameover_me, :sounds, :test_battlers, :test_troop_id, :start_map_id, :start_x, :start_y, :terms, :battleback1_name, :battleback2_name, :battler_name, :battler_hue, :edit_map_id
  end


  # RPG::System::Vehicle Compatible
  class RgssCompatible::Vxace::System::Vehicle < RgssCompatible
    create_accessors :character_name, :character_index, :bgm, :start_map_id, :start_x, :start_y
  end

  # RPG::System::Terms Compatible
  class RgssCompatible::Vxace::System::Terms < RgssCompatible
    create_accessors :basic, :params, :etypes, :commands
  end

  # RPG::System::TestBattler Compatible
  class RgssCompatible::Vxace::System::TestBattler < RgssCompatible
    create_accessors :actor_id, :level, :equips
  end

  # RPG::AudioFile Compatible
  class RgssCompatible::Vxace::AudioFile < RgssCompatible
    create_accessors :name, :volume, :pitch
  end

  # RPG::BGM Compatible
  class RgssCompatible::Vxace::BGM < RgssCompatible::Vxace::AudioFile
    create_accessors :pos
  end

  # RPG::BGS Compatible
  class RgssCompatible::Vxace::BGS < RgssCompatible::Vxace::AudioFile
    create_accessors :pos
  end

  # RPG::ME Compatible
  class RgssCompatible::Vxace::ME < RgssCompatible::Vxace::AudioFile
  end

  # RPG::SE Compatible
  class RgssCompatible::Vxace::SE < RgssCompatible::Vxace::AudioFile
  end
  
end
