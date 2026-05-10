
SMODS.Back {
    key = 'rerun_deck',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            currentante = 0
        },
    },
    loc_txt = {
        name = 'Rerun Deck',
        text = {
            [1] = 'Rerun the game after ante 8.',
            [2] = '{C:attention}+1{} Joker slot per rerun',
            [3] = 'Rerun costs half your money',
            [4] = '3x base blind score per rerun'
        },
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'CustomDecks',
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            if ((G.GAME.pool_flags.rerundec_loop_active or false) and G.GAME.blind.boss and to_big(G.GAME.round_resets.ante) == to_big(8)) then
                for i = 1, 1 do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if G.consumeables.config.card_limit > #G.consumeables.cards + G.GAME.consumeable_buffer then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            end
                            
                            
                            play_sound('timpani')
                            SMODS.add_card({ set = 'rerun_set', edition = 'e_negative', key = 'c_mycustom_reruncard'
                            })
                            return true
                        end
                    }))
                end
                for i = 1, 1 do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if G.consumeables.config.card_limit > #G.consumeables.cards + G.GAME.consumeable_buffer then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            end
                            
                            
                            play_sound('timpani')
                            SMODS.add_card({ set = 'rerun_set', edition = 'e_negative', key = 'c_mycustom_breaktheloop'
                            })
                            return true
                        end
                    }))
                end
            end
        end
    end,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                card_eval_status_text(self, 'extra', nil, nil, nil, {message = "loop_active", colour = G.C.BLUE})
                G.GAME.pool_flags.rerundec_loop_active = true
                return true
            end
        }))
        G.GAME.starting_params.dollars = G.GAME.starting_params.dollars +16
        return {
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.interest_cap = G.GAME.interest_cap +10
                    return true
                end
            }))
            
        }
    end
}