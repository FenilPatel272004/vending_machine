## 🔍 Code Blame: `vending_machine.v` & `vending_machine_tb.v`

This section breaks down the responsibility for each part of the vending machine design and testbench.

---

### 🧠 `vending_machine.v`

- **State Machine Design (Lines 15–27):**  
  Implements a 5-state FSM (`ideal`, `take_input`, `calculation`, `give_change`, `final`) to handle user interactions, money input, item selection, and dispensing.  
  > _Blame: The architect of vending logic and state control._

- **State Transitions (Lines 29–39):**  
  Decides how the FSM moves from one state to another based on current inputs.  
  > _Blame: Logic designer who loves edge cases._

- **Functional Logic for Each State (Lines 42–99):**  
  Handles actual data processing like updating amount, computing item costs, change calculation, and assigning item counters.  
  > _Blame: The one who still counts change manually._

- **Change Distribution (Lines 88–93):**  
  Smartly breaks change into Rs. 100/50/20/10/5 using division and modulus — no infinite loops here.  
  > _Blame: Math genius (or someone who just hates vending machines that say “exact change only”)._

- **Item Dispense Signal (Line 101):**  
  `assign item_out = ...` ensures the output item is signaled only in the final state if item count > 0.  
  > _Blame: Signal perfectionist._

---

### 🧪 `vending_machine_tb.v`

- **Testbench Setup (Lines 1–17):**  
  Declares inputs, outputs, and instantiates the DUT. Wire up and let the simulation roll.  
  > _Blame: Verification engineer with a love for clean structure._

- **Display & Monitoring (Lines 19–25):**  
  Uses `$display` to show what’s happening in each cycle. Helps debug what you bought and what change you got.  
  > _Blame: Console spammer — but in a helpful way._

- **Waveform Dumping (Lines 27–29):**  
  Dumps waveform data into `wave_vending_machine.vcd`.  
  > _Blame: Someone who lives in GTKWave._

- **Test Scenarios (Lines 33–99):**  
  Covers multiple realistic use cases:
  - Exact amount for an item
  - Insufficient balance
  - Multiple purchases with one-time input
  - Change return logic  
  > _Blame: QA tester who’s tired of hungry vending machines._

---

### 🖼️ `state_diagram.jpeg`

- Visual FSM reference for understanding state transitions and flow.  
  > _Blame: The only person who believes in documentation._
