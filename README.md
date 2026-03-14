# lex-executive-function

Executive function modeling for the LegionIO brain-modeled cognitive architecture.

## What It Does

Implements the prefrontal cortex executive control system. Models the three core executive functions: working memory updating, cognitive flexibility (task switching), and inhibitory control. Manages a goal stack (up to 7 concurrent goals), tracks cognitive load, and gates complex actions based on executive capacity. High load blocks new goals; high recent switching reduces flexibility; inhibited responses are blocked from re-execution.

Based on Miyake et al.'s unity/diversity framework for executive functions.

## Usage

```ruby
client = Legion::Extensions::ExecutiveFunction::Client.new

# Set a goal on the stack
client.set_goal(goal: 'refactor authentication module', domain: :coding, priority: 0.8)
# => { success: true, goal_id: "...", stack_position: 1, cognitive_load: 0.1 }

# Switch between tasks
client.switch_task(from_goal_id: '...', to_goal_id: '...')
# => { success: true, switched: true, switch_cost: 0.15, cognitive_load: 0.25, permitted: true }

# Inhibit a response (block it from executing)
client.inhibit_response(response: :send_unreviewed_code, inhibition_type: :response, domain: :coding)

# Update working memory
client.update_working_memory(item: { context: 'auth_module', file: 'auth.rb' }, operation: :add)

# Check current executive state
client.cognitive_load_status
# => { load: 0.3, load_label: :low, goal_count: 3, working_memory_size: 4 }

# Check if task switching is permitted
client.flexibility_assessment
# => { flexibility_score: 0.7, switch_permitted: true, recent_switch_count: 3 }

# Complete a goal (reduces cognitive load)
client.complete_goal(goal_id: '...')

# Periodic maintenance
client.update_executive_function
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
