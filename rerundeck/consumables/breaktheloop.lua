
SMODS.Consumable {
    key = 'breaktheloop',
    set = 'rerun_set',
    pos = { x = 1, y = 0 },
    config = { 
        extra = {
            all_blinds_size0 = 1   
        } 
    },
    loc_txt = {
        name = 'Break the Loop',
        text = {
            [1] = 'Continue into real endless mode.',
            [2] = 'Resets blind scaling back to base'
        }
    },
    cost = 0,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                used_card:juice_up(0.3, 0.5)
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "loop_active", colour = G.C.BLUE})
                G.GAME.pool_flags.mycustom_loop_active = false
                return true
            end
        }))
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.starting_params.ante_scaling = 1
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}