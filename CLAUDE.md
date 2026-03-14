# lex-executive-function

**Level 3 Documentation** — Parent: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## Purpose

Executive function modeling for the LegionIO cognitive architecture. Implements the prefrontal cortex executive control system — the set of cognitive processes that regulate, control, and manage other cognitive processes. Models the three core executive functions: working memory updating, cognitive flexibility (task switching), and inhibitory control. Manages a goal stack, tracks cognitive load, and gates complex actions based on executive capacity.

Based on Miyake et al.'s unity/diversity framework for executive functions.

## Gem Info

- **Gem name**: `lex-executive-function`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::ExecutiveFunction`
- **Location**: `extensions-agentic/lex-executive-function/`

## File Structure

```
lib/legion/extensions/executive_function/
  executive_function.rb         # Top-level requires
  version.rb                    # VERSION = '0.1.0'
  client.rb                     # Client class
  helpers/
    constants.rb                # EXECUTIVE_CAPACITIES, LOAD_LEVELS, INHIBITION_TYPES, thresholds
    goal.rb                     # Goal value object with priority and status
    executive_engine.rb         # Engine: goal stack, cognitive load, inhibition, flexibility
  runners/
    executive_function.rb       # Runner module: all public methods
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `GOAL_STACK_LIMIT` | 7 | Maximum concurrent goals (Miller's Law) |
| `COGNITIVE_LOAD_CEILING` | 1.0 | Maximum load (full capacity) |
| `LOAD_COST_PER_GOAL` | 0.1 | Load added per active goal |
| `SWITCH_COST` | 0.15 | Cognitive load cost for task switching |
| `INHIBITION_STRENGTH` | 0.8 | Default suppression level for inhibited responses |
| `FLEXIBILITY_THRESHOLD` | 0.4 | Minimum flexibility score to permit task switching |
| `LOAD_DECAY` | 0.05 | Cognitive load reduction per maintenance cycle |
| `MAX_GOALS` | 200 | Total goal history cap |
| `INHIBITION_TYPES` | `[:response, :distractor, :proactive, :reactive]` | Types of inhibitory control |
| `LOAD_LABELS` | range hash | `overloaded / high / moderate / low / minimal` |
| `GOAL_STATES` | `[:pending, :active, :completed, :abandoned, :inhibited]` | Goal lifecycle |

## Runners

All methods in `Legion::Extensions::ExecutiveFunction::Runners::ExecutiveFunction`.

| Method | Key Args | Returns |
|---|---|---|
| `set_goal` | `goal:, domain:, priority: 0.5, context: {}` | `{ success:, goal_id:, stack_position:, cognitive_load: }` |
| `complete_goal` | `goal_id:` | `{ success:, goal_id:, completed:, cognitive_load: }` |
| `abandon_goal` | `goal_id:, reason: nil` | `{ success:, goal_id:, abandoned: }` |
| `inhibit_response` | `response:, inhibition_type:, domain: nil` | `{ success:, inhibited:, inhibition_strength:, load_cost: }` |
| `switch_task` | `from_goal_id:, to_goal_id:` | `{ success:, switched:, switch_cost:, cognitive_load:, permitted: }` |
| `update_working_memory` | `item:, operation: :add` | `{ success:, operation:, item:, working_memory_size: }` |
| `cognitive_load_status` | — | `{ success:, load:, load_label:, goal_count:, working_memory_size: }` |
| `active_goals` | — | `{ success:, goals:, count: }` (sorted by priority) |
| `flexibility_assessment` | — | `{ success:, flexibility_score:, switch_permitted:, recent_switch_count: }` |
| `update_executive_function` | — | `{ success:, load_decayed:, goals_pruned: }` |
| `executive_function_stats` | — | Full stats hash |

## Helpers

### `Goal`
Value object. Attributes: `id`, `goal`, `domain`, `priority`, `state`, `context`, `created_at`, `completed_at`. Key methods: `activate!`, `complete!`, `abandon!(reason:)`, `inhibit!`, `active?`, `to_h`.

### `ExecutiveEngine`
Central state: `@goals` (array), `@working_memory` (array, capped at 7), `@cognitive_load` (float 0–1), `@inhibited_responses` (hash by response). Key methods:
- `set_goal(...)`: pushes goal to stack, computes new cognitive load (`active_goals * LOAD_COST_PER_GOAL`), oldest goal evicted if stack at limit
- `switch_task(from:, to:)`: checks flexibility score, deducts `SWITCH_COST` from flexibility, adds load
- `inhibit(response:, type:)`: stores response in `@inhibited_responses`, blocks future execution
- `update_memory(item:, operation:)`: add/remove/clear operations on `@working_memory` (ring buffer)
- `flexibility_score`: `1.0 - (recent_switch_count * 0.1)` — switching reduces future flexibility
- `decay_load`: reduces `@cognitive_load` by `LOAD_DECAY` per cycle, floors at 0.0

## Integration Points

- `cognitive_load_status[:load]` gates lex-tick's `action_selection` — overloaded executive cannot add new goals
- `active_goals` provides the agent's current intention stack for lex-prediction's forward model
- `inhibit_response` called when lex-consent or lex-governance denies an action — prevents re-attempt
- `flexibility_assessment[:switch_permitted]` governs lex-tick mode transitions (task switch = mode switch)
- `update_working_memory` called at each lex-tick phase to maintain current context window
- `update_executive_function` maps to lex-tick's periodic maintenance cycle

## Development Notes

- Goal stack priority: goals are sorted by priority for display; lower-priority goals are evicted first at GOAL_STACK_LIMIT
- Cognitive load is recomputed from active goal count, not accumulated — completion immediately reduces load
- Working memory ring buffer: when at capacity, oldest item is removed on `:add` operation
- Flexibility score can go negative if many recent switches occur; floored at 0.0 before comparison to threshold
- `GOAL_STACK_LIMIT = 7` references Miller's Law (7±2 chunks) intentionally for the cognitive modeling theme
