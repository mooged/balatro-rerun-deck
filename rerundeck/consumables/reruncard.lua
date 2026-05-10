
SMODS.Consumable {
    key = 'reruncard',
    set = 'rerun_set',
    pos = { x = 0, y = 0 },
    config = { 
        extra = {
            ante_value0 = 1,
            dollars0 = 2,
            all_blinds_size0 = 3   
        } 
    },
    loc_txt = {
        name = 'Rerun Card',
        text = {
            [1] = 'Reset ante to 1',
            [2] = 'Each reset 3x Blind Requirement',
            [3] = 'Add a joker slot'
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
        if ((G.GAME.pool_flags.rerundec_loop_active or false) and to_big(G.GAME.round_resets.ante) == to_big(9) or to_big(G.GAME.round_resets.ante) == to_big(8)) then
            local mod = 1 - G.GAME.round_resets.ante
            ease_ante(mod)
            G.E_MANAGER:add_event(Event({
                func = function()
                    
                    G.GAME.round_resets.blind_ante = 1
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "Ante set to "..tostring(1), colour = G.C.YELLOW})
                    return true
                end,
            }))
            delay(0.6)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+"..tostring(1).." Joker Slot", colour = G.C.DARK_EDITION})
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    return true
                end
            }))
            delay(0.6)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars / 2
                    local dollar_value = target_dollars - current_dollars
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "/"..tostring(2).." $", colour = G.C.RED})
                    ease_dollars(dollar_value, true)
                    return true
                end
            }))
            delay(0.6)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 3
                    return true
                end
            }))
        end
    end,
    can_use = function(self, card)
        return (((G.GAME.pool_flags.rerundec_loop_active or false) and to_big(G.GAME.round_resets.ante) == to_big(9) or to_big(G.GAME.round_resets.ante) == to_big(8)))
    end
}