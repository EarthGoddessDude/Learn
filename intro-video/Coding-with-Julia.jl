### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 009b8e21-a7a2-41d0-af6c-5be89ea819f7
begin 
	using CondaPkg; CondaPkg.add("seaborn");
	using PythonCall, RDatasets;
end

# ╔═╡ 4daea69e-a4b5-48f6-b932-b90a38544105
using BenchmarkTools

# ╔═╡ 1c0ccd93-59b8-46e2-bf3a-45ae79b35af0
using MortalityTables, Yields, LifeContingencies, ActuaryUtilities

# ╔═╡ 8320edcc-ef78-11ec-0445-b100a477c027
begin 
	using PlutoUI
	
end

# ╔═╡ 3c2da572-90d0-4206-9586-18f2cea6b6ca
md"# Coding the Future, *with Julia*"

# ╔═╡ 458f2690-e3fb-40a8-a657-e3a0666af69c
html"<button onclick='present()'>present</button>"

# ╔═╡ 142954b2-9615-4527-9a1a-d687583ff38e
md"""
# Outline for today

1. Three short tales for why coding should matter to actuaries
2. A 10,000 foot overview of "Why Julia?"
3. An intro to Julia via Retention Modeling
4. An overview of JuliaActuary packages

"""

# ╔═╡ 0c351b21-f3ee-43ee-8cb0-fb0faf003c84
md"""
# Motivation: Why code?


## A bicycle for the mind

$(Resource("https://abhisays.com/wp-content/uploads/2012/03/steve-jobs-1980.jpg"))

## Escaping Flatlad

$(Resource("https://www.sfbok.se/sites/default/files/styles/large/sfbok/sfbokbilder/212/212165.jpg?bust=1596631499&itok=Gy2Ix0y-"))

## Competive Dynamics

$(Resource("https://prodimage.images-bn.com/pimages/9780674258662_p0_v1_s1200x630.jpg"))

$(Resource("/Desktop/Digital vs Traditional.png"))
"""

# ╔═╡ 47c7ecd8-1610-4ce8-bff1-814a48336368
md"# Why Julia

- Highly expressiveness and pleasant syntax
- High performance in a high level language
- Modern tooling and large ecosystem

"

# ╔═╡ 7b86f12b-de88-40e0-bee3-1d9ba188fd40
md"""
## Who uses Julia today?

$(Resource("/Desktop/Julia Users.png"))
"""

# ╔═╡ a1ea0a4f-8074-4a3f-a88b-eb9f4e8ece3d
md"""
## Modern tooling and large ecosystem

$(Resource("https://imgs.xkcd.com/comics/python_environment.png"))

### Reproducibility and Environment Management

Julia *environments* are defined by the precense of two files:

#### `Project.toml`

This defines the project and its dependencies:

```toml
# Project.toml
name = "ActuaryUtilities"
uuid = "bdd23359-8b1c-4f88-b89b-d11982a786f4"
authors = ["Alec Loudenback"]
version = "3.4.0"

[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
... more...

[compat]
Distributions = "0.23,0.24,0.25"
ForwardDiff = "^0.10"
QuadGK = "^2"
...more...

```

#### `Manifest.toml`

After *resolving* package versions in the `Project.toml` file, it will record the exact set of packages used. You can share this file with your project, and someone else can `instantiate` with the exact same set of packages/versions that you used (as long as OS and Julia version is the same).

```toml
#Manifest.toml
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "7d255eb1d2e409335835dc8624c35d97453011eb"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.14"
... more...
```

### Package Management

Built-in `Pkg.jl` allows:

- Package installation and management
- Stacked environments keeps projects distinct and non-conflicting
- Using combined public and private repositories 
  - at its simplest, registries are just git repositories, nothing fancy!


### Artifacts

Julia has an Artifacts system, which allows it to bundle platform-specific dependencies/binaries, and data. 

**Example:** a copy of the entire [Mort.SOA.org](https://mort.soa.org/) table set is included as a <10MB file with [MortalityTables.jl](https://github.com/JuliaActuary/MortalityTables.jl)


### Ecosystem


There are ~8000 registered packages as of July 2022. 

Julia has very robust, and in many cases industry leading packages in:

- DataFrames and Datascience
- Statistics 
- Optimization
- Computational interaction (like Pluto!)
- Automatic differentiation
- Machine learning
- Differential Equations
- ... many more...


"""

# ╔═╡ baee42c3-b745-4657-8904-56e3f69c66ca
md"""
### Testing and Documentation built in

Testing and documentation is as important to ensure high quality packages. Because Julia has such easy tools, Julia likely has some of the highest proportion of registered pacakges with documenation strings and tests for packages.

```julia
using Test

@test 1 + 1 == 2
```


Simply adding comments creates documenation that is accessible interactively and with built documenation pages (include math support!):

"""

# ╔═╡ 4b92b938-b5e1-4389-9a94-f8ded9d8c4d9
"""
	mysum(a,b)

Sum numbers `a` and `b`:

``(a + b) = c ``
"""
function mysum(a,b)
   return a + b
end

# ╔═╡ 9a237e79-80ec-4dce-a3f4-4856ae8dcd5b
mysum(1,2)

# ╔═╡ 93647fd4-e466-48d1-b2e4-eb47d3e0f813
md""" 

### Open ecosystem and range of tools

$(Resource("https://www.julia-vscode.org/img/newscreen1.png"))

- Interactive REPL
- Debugger
- Dynamic recompiliation (see `Revise.jl`)
- Can use preferred editor (VS Code is IMO best option for most users)
  - comparable to RStudio experience for R users
    - Variable browser
    - plotting pane
    - documentation
    - intelligent auto-complete
    - integrated REPL
- Notebooks (Jupyter and Pluto)


"""

# ╔═╡ 721d4318-071b-4ff2-a29f-a005b4ff2ffc
md"""
### Python and R Integration

Use existing Python and R code/libraries:
"""

# ╔═╡ 3691567a-9d96-4fcf-a02a-30b716944a90
iris = dataset("datasets","iris")

# ╔═╡ 1d6c8644-fe0e-48c7-8bf0-e69ce366922a
begin
	sns = pyimport("seaborn")
	sns.pairplot(pytable(iris),hue="Species")
end
	

# ╔═╡ fb686b8b-bbb8-43b5-8241-493463275346
md"""
## Expressiveness and pleasant syntax

### Expresiveness

Accomplish similar tasks with less code, written in an easy-to-understand way:

```python
# Python
x = np.arange(15, dtype=np.int64).reshape(3, 5)
```

```julia
# Julia
x = reshape(0:14, 3,5)
```
"""

# ╔═╡ f23b4b4e-baf5-4a7d-9a33-14050f1993e6
reshape(0:14,3,5) # can infer type from 0 or 0.

# ╔═╡ 5c811d55-53df-4a9c-b75f-4656168b70e2
md"""
### Programming paradigm

Julia is multi-paradigm, which means you create code in your own style, or the style that best suits the problem at hand.

- Functional
- Object Oriented
  - Multiple dispatch is an extension of single dispatch commonly associated with OOP
- Data Oriented
- Domain-Specific-Language
- Concurency/Parallel
- Literate
- ...

Sometimes this can be a pitfall, as there's not one cannonical way to accomplish some things.

"""

# ╔═╡ 48ac1891-9047-47bf-9536-ec841c746907
md"""
### Unicode 

**Example**: Black scholes $$d_1$$ component:

```math
d_1 = \frac{\ln\left(\frac{S}{K}\right) + \tau\left(r + \frac{\sigma^2}{2}\right)}{\sigma\sqrt{\tau}} \\
```

```julia
function d1(S, K, τ, r, σ, q)
    return (log(S / K) +  τ * (r - q + σ^2 / 2)) / (σ * √(τ))
end
```

**Easy to type:** `\sigma[TAB]` creates `σ`
"""

# ╔═╡ 0fa9947b-0d09-416f-869e-4b62861cdcc7
md"""
### Broadcasting 

Simple syntax to automatically extend functionality to work on single arguments 
"""

# ╔═╡ e8696f90-3295-4054-89ca-9ef21595d036
ispositive(x) = x ≥ 0

# ╔═╡ 80b2e45b-e024-4b3b-9d6d-bf67ba0bddfb
md"We didn't define how this would work on arrays:"

# ╔═╡ e26e3daf-ee55-434d-9d46-c083537df72a
ispositive([1,2,3])

# ╔═╡ 47556a7c-230a-4211-af06-f6fb61fbd7c1
md"But we can broadcast (using the dot, `.`) across arrays:"

# ╔═╡ ae5ed9ec-c4a3-4765-a3e2-35e9e2a285f1
ispositive.([1,2,3])

# ╔═╡ 6e4662da-72a5-42a5-80c5-a5846513a1ff
md"""
### Macros and Introspection

Code itself can be operated on!

It's not unique to Julia, but never before bundled with such a dynamic and performant language.

This capability is what enables Pluto notebooks!
"""

# ╔═╡ 8855b283-153e-4b9c-9758-97e0dea133a4
md"""

#### Tangent #1 - Pluto Notebooks

Simiilar in concept to Jupyter (**Julia**, **Pyt**hon, **R**), but has the following advantages, IMO:

- Reactive (each cell knows about and understands the others)
- Version-controll-able (each notebook is just a plain `.jl` Julia file)
- First class interactivity (add slides, buttons, etc. for dynamicism)
"""

# ╔═╡ 37e2e205-0c7e-4135-9e25-901d03fe38a1
md"""
### Macros

Kind of like "magics" in Jupyter/Python, but even more powerful and language-wide.

(Macros are a more advanced topic to *create*, but very easy to *use*.)
"""

# ╔═╡ 519a702a-0dfd-4ecd-a66e-58a5bac0d97b
@benchmark sum(0:1000000)

# ╔═╡ adcc763b-b35d-4e3d-af26-dcbe3e648830
md"#### Introspection"

# ╔═╡ 6124bd7b-b49e-42c8-9957-5425d78420a8
@code_warntype sum(0:1000000)
# @code_llvm sum(0:1000000)
# @code_native sum(0:1000000)

# ╔═╡ c414d316-454e-4a0c-aeac-54826cc6b203
md"""
### Other cool macros

- `@edit` will open the function to edit in your default editor
- `@which` will indicate where the function you are using is defined

Performance optimzers (use with special consideration):

- `@inbounds` will disable index checking on arrays
- `@simd` wiil parrallelize within a CPU core (single instruction, multiple dispatch)
- `@threads` will split computation across CPU threads
- `@fastmasth` will allow compiler to re-arange math operations for performance, but at the cost of accuracy!

"""

# ╔═╡ b77156a3-1180-434e-90ec-841b8ef8d632
md"""
## High Performance in a high level language

Julia is compiled *just ahead of time* which is different than Python and R, which are interpreted. 

- *Compiled* means translated to efficient machine code in advance of actually running the code 
- *Interpreted* means that when the code is run, each line is effectively translated on-the-fly


### TTFX 

The trade-off with Julai is that compilation has to happen *at some point* but because of its dynamic nature, it can't be *all in advance*. The leads to "TTFX", or "time-to-first-X" issues where, e.g. it can be a number of seconds before your first plot renders, but then subequently in the same session the plot will render very quickly.

Work on this area to re-use compiled code between Julia sessions is ongoing and expected to improve in future Julia versions.

"""

# ╔═╡ ae022006-fd36-45c0-a68b-a754505db1f0
md"""
Despite being compiled, Julia is *dynamic*, in that it's easy to incrementally and interactively write code. Like this notebook!
"""

# ╔═╡ e4266932-a4c6-4345-ae62-e18a0561dcb2
md"""
### The "Life modeling problem" benchmarks

$(Resource("https://d33wubrfki0l68.cloudfront.net/66d90b5ada11fc740cec59cc8ca00f70ba0bfe92/05f69/assets/benchmarks/code/output/lmp_benchmarks.svg"))

### General benchmarks

Julia can actually be faster than the equivalent C code because the compiler can optimize what you write:
$(Resource("https://julialang.org/assets/images/benchmarks.svg"))
"""

# ╔═╡ 7beb3fff-6845-4f60-85cf-aa8b74e0664e
md""" 
# Live Julia example - Retention analysis

In this short example, we'll see some examples of Julia code in action as we analyze policy-level retained mortality risk at both a life and policy level:
"""

# ╔═╡ c2411811-0d9f-4ebc-b6d8-b81280d6060d
md"""
## Datastructures

A `Life` can have `Policy`s, each of which can have multiple `Cessions` to a reinsurer:

"""

# ╔═╡ 1b9285cc-1ef5-495d-ab14-5515509f8d21
struct Life
  policies
end

# ╔═╡ a2eedbb6-679a-4796-b226-bf7f62d7d38e
struct Policy
  face
  cessions
 end

# ╔═╡ eeaeae8f-f4ec-489e-bc41-a46cddd1f0b1
struct Cession
  ceded
end

# ╔═╡ a9961f0d-080b-40d3-b59b-2f687ce9b833
md""" 
Methods (specific instances of a general function) in Julia aren't tied to classes (single dispatch) because in Julia, the *combination* of arguments defines which method to use (multiple dispatch).

"""

# ╔═╡ 62c5eec4-f540-4884-9612-05c5b5e826d9
function retained(pol::Policy)
  pol.face - sum(cession.ceded for cession in pol.cessions)
end

# ╔═╡ f4fbccda-286d-42cb-93e7-93654b8d7892
pol_1 = Policy( 1000, [ Cession(100), Cession(500)] )

# ╔═╡ 63a43efc-751a-49f2-8ff3-e47c44e2d627
pol_2 = Policy( 2500, [ Cession(1000) ] )

# ╔═╡ 6cdbbece-0b44-4931-b167-801c698ab2c3
life = Life([pol_1, pol_2])

# ╔═╡ 81070c4e-1d96-41c2-b4db-c9938633fe7f
function retained(l::Life)
  sum(retained(policy) for policy in life.policies)
end

# ╔═╡ 18517698-7727-42f9-a378-02955793c422
retained(pol_1)

# ╔═╡ d6d07e01-7966-412c-a2c1-61e05955f8bd
retained(life)

# ╔═╡ ca14f376-b2d7-411f-9702-d496390eb45e
md"""

### Broadcasting our own function

"""

# ╔═╡ d49c5675-42d1-4ccf-a0df-4eb49bc9de0f
retained.(life.policies)

# ╔═╡ e94fc916-27a9-448d-9237-65a8e954e2af
md"""
# JuliaActuary

A suite of packages intended to make actuarial work very easy. Created by several contributors including myself.

The homepage at [https://juliaactuary.org/](https://juliaactuary.org/) has documentation, tutorials, interactive notebooks, blogs, and community/contributing guidelines.

## Released packages

- MortalityTables.jl
  - Easily work with standard mort.SOA.org tables and parametric models with common survival calculations.

- LifeContingencies.jl
  - Insurance, annuity, premium, and reserve maths.

- ActuaryUtilities.jl
  - Robust and fast calculations for internal_rate_of_return, duration, convexity, present_value, breakeven, and other commonly used routines in insurance.

- Yields.jl
  - Simple and composable yield curves and calculations.

- ExperienceAnalysis.jl
  - Meeting your exposure calculation needs.

## In development packages

- EconomicScenarioGenerators.jl
  - Create Yields.jl compatible stochastic economic scenarios

- Chainladder.jl
  - Claims triangles utilities



"""

# ╔═╡ be39b864-45cb-480d-9bb2-67d56a495147
md"## An integrated example"

# ╔═╡ af9484e7-7f5c-448e-9b49-a2a9adbcc596
md"""

### Yields and Rates

#### `Rate`s

`Rate`s are a type defined in Yields.jl:
"""

# ╔═╡ f506bcbe-4d67-4e61-8b2f-af23b0ddf1cd
rates = [
	Periodic(0.04, 1),
	Periodic(0.04, 2),
	Continuous(0.04),
]
	

# ╔═╡ b3238c9a-a7bc-4dbe-9657-fc23144a400c
c = Continuous(0.04)

# ╔═╡ 969ecaae-c39c-46e6-b7b8-0c6fd910339b
accumulation.(rates,1)

# ╔═╡ 119b6051-c1f3-41e5-a415-4358d1366703
discount.(rates,1)

# ╔═╡ e92df94f-cb38-486f-89be-5b8a39aa59c9
yield = let 
	# 2021-03-31 rates from Treasury.gov
	rates = [0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100

	maturities = [1 / 12, 2 / 12, 3 / 12, 6 / 12, 1, 2, 3, 5, 7, 10, 20, 30]
	yield = Yields.CMT(rates, maturities)
end

# ╔═╡ a0af8bfc-357c-452f-9b0f-4b6bef4c2714
md" ### Mortality and other rate tables

For example, the [2001 VBT Male NS table](https://mort.soa.org/ViewTable.aspx?&TableIdentity=1118)"

# ╔═╡ 663067a1-704d-4a1a-bf26-1bccb160bc67
vbt2001 = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

# ╔═╡ 4a906be4-9c1e-459e-84e0-394601c57a00
md" The table is indexed by issue and attained age, e.g. select rates for ages 65-75 to a policy underwritten at age 65:"

# ╔═╡ 0d387f41-24a5-4233-b229-15ada348a20a
vbt2001.select[65][65:75]

# ╔═╡ d84db7cb-49e1-4cba-9b9d-b593b0151aeb
vbt2001.select

# ╔═╡ 3253db45-ebd8-4047-8182-45fe5a1305e4
vbt2001.ultimate

# ╔═╡ 7238532c-f2b0-4b63-b028-109caf2c196b
md"#### Survival and decrements"

# ╔═╡ 9675af2c-f6e1-4fbb-8b85-221226d0bd2b
survival(vbt2001.ultimate,65,75), decrement(vbt2001.ultimate,65,75)

# ╔═╡ 0165537c-7735-4a07-859a-a09a43f4b494
md"### Life Contingencies"

# ╔═╡ 5332aae1-11ff-42f4-adbf-b131a8b238bc
issue_age = 30

# ╔═╡ 5b690c88-7cb6-4618-9980-933789bf51c2
l = SingleLife(mortality=vbt2001.select[issue_age])

# ╔═╡ b20695b9-b1c3-44c6-9e7e-8927ba007fae
# actuarial present value of Whole Life insurance
insurance = Insurance(LifeContingency(l, yield))

# ╔═╡ c2f6787b-e7d4-4c7e-ab31-f5cad6e75929
cashflows(insurance) |> collect

# ╔═╡ a645d95a-ebb1-4d48-83c0-830faa754f31
timepoints(insurance) |> collect

# ╔═╡ e40482d8-0a49-4681-aa3f-8c04e1f80c96
probability(insurance) |> collect

# ╔═╡ f5c0f9bc-1032-4ab8-b7bd-8149e8d77118
benefit(insurance) 

# ╔═╡ c96d27e5-fe7a-46a4-944c-38b767e1b885
survival(insurance) |> collect

# ╔═╡ a132b7ea-dbe4-4869-b6a0-417b49517234
md"
Note that these functions are lazily determined - it's much faster to perform calculations on **non-allocated** values than on fully-insantiated arrays.

Simple example:"

# ╔═╡ a74b7bd9-7869-44a4-b51d-fe400ba70e89
@btime sum(x^2 for x in 1:1_000) # add squares up to 1000

# ╔═╡ 3582a3c0-c156-4c60-b622-760dd55f552b
@btime sum([x^2 for x in 1:1_000]) # add the array which contains squards up to 1000

# ╔═╡ de6303ac-8da9-4848-ad7e-714ca2c894bb
md"### Financial Maths"

# ╔═╡ 5405b11b-288e-4e06-917c-1eb6a82a1ac9
pv(insurance)

# ╔═╡ 00567c83-29fc-47a8-911a-a28e77ded7b2
duration(yield,cashflows(insurance))

# ╔═╡ 94264fcb-b69f-4f9b-b8bb-83c31e22ffb1
convexity(yield,cashflows(insurance))

# ╔═╡ 4cb7f1e1-8a07-4bd3-b92e-1a6c0ff3698f
reserve = pv(yield,cashflows(insurance))

# ╔═╡ d73421f8-e2e9-4b9a-90af-d7625a1d30c5
# `...` splats the lazy values into an array
cf_vector = [-reserve;cashflows(insurance)...]

# ╔═╡ 0bfc0522-10a1-4d08-a8fb-5c0dcbe1db77
irr(cf_vector)

# ╔═╡ c7da89f1-33f2-44e9-aa30-49f7da89632d
@bind reserve_scalar Slider(0.9:0.01:1.1,default=1;show_value=true)

# ╔═╡ 6d405814-7f56-4534-abc8-262a7f5a1750
let 
	cfs = [
		-reserve * reserve_scalar;
		cashflows(insurance)...
	]
	
	irr(cfs)
end

# ╔═╡ 3b3c4951-7c85-41b1-9f5b-1a23f4b4c465
md""" # Endnotes

## Colophon

## References

[^1]: [Co-evolution of Information Processing Technology and Use: Interaction Between the Life Insurance and Tabulating Industries](https://dspace.mit.edu/bitstream/handle/1721.1/2472/swp-3575-28521189.pdf?sequence=1)
"""

# ╔═╡ f1675cb1-ece0-4a5f-a0eb-7fd16010461c
md"## Packages"

# ╔═╡ 1e3e432b-3027-4dfe-992c-14189f675181
TableOfContents()

# ╔═╡ e536d967-ba2f-4a06-b159-a652e22d30af
# 9e5d37c8-c45c-4eb0-bc38-fd42bb408508
html"""
<script>
    const calculate_slide_positions = (/** @type {Event} */ e) => {
        const notebook_node = /** @type {HTMLElement?} */ (e.target)?.closest("pluto-editor")?.querySelector("pluto-notebook")
		console.log(e.target)
        if (!notebook_node) return []

        const height = window.innerHeight
        const headers = Array.from(notebook_node.querySelectorAll("pluto-output h1, pluto-output h2"))
        const pos = headers.map((el) => el.getBoundingClientRect())
        const edges = pos.map((rect) => rect.top + window.pageYOffset)

        edges.push(notebook_node.getBoundingClientRect().bottom + window.pageYOffset)

        const scrollPositions = headers.map((el, i) => {
            if (el.tagName == "H1") {
                // center vertically
                const slideHeight = edges[i + 1] - edges[i] - height
                return edges[i] - Math.max(0, (height - slideHeight) / 2)
            } else {
                // align to top
                return edges[i] - 20
            }
        })

        return scrollPositions
    }

    const go_previous_slide = (/** @type {Event} */ e) => {
        const positions = calculate_slide_positions(e)
        const pos = positions.reverse().find((y) => y < window.pageYOffset - 10)
        if (pos) window.scrollTo(window.pageXOffset, pos)
    }

    const go_next_slide = (/** @type {Event} */ e) => {
        const positions = calculate_slide_positions(e)
        const pos = positions.find((y) => y - 10 > window.pageYOffset)
        if (pos) window.scrollTo(window.pageXOffset, pos)
    }

	const left_button = document.querySelector(".changeslide.prev")
	const right_button = document.querySelector(".changeslide.next")

	left_button.addEventListener("click", go_previous_slide)
	right_button.addEventListener("click", go_next_slide)
</script>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ActuaryUtilities = "bdd23359-8b1c-4f88-b89b-d11982a786f4"
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CondaPkg = "992eb4ea-22a4-4c89-a5bb-47a3300528ab"
LifeContingencies = "c8f0d631-89cd-4a1f-93d0-7542c3692561"
MortalityTables = "4780e19d-04b9-53dc-86c2-9e9aa59b5a12"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
RDatasets = "ce6b1742-4840-55fa-b093-852dadbb1d8b"
Yields = "d7e99b2f-e7f3-4d9e-9f01-2338fc023ad3"

[compat]
ActuaryUtilities = "~3.4.1"
BenchmarkTools = "~1.3.1"
CondaPkg = "~0.2.11"
LifeContingencies = "~2.2.0"
MortalityTables = "~2.3.0"
PlutoUI = "~0.7.39"
PythonCall = "~0.9.3"
RDatasets = "~0.7.7"
Yields = "~3.1.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-DEV"
manifest_format = "2.0"
project_hash = "fb5a0e480f5e7eae8d29bffeca3b31af1a94442b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ActuaryUtilities]]
deps = ["Dates", "Distributions", "ForwardDiff", "QuadGK", "Roots", "StatsBase", "Yields"]
git-tree-sha1 = "f3dc5d32d1808eaa722339bbb97decb5978b3cbe"
uuid = "bdd23359-8b1c-4f88-b89b-d11982a786f4"
version = "3.4.1"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "7d255eb1d2e409335835dc8624c35d97453011eb"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.14"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "26c659b14c4dc109b6b9c3398e4455eebc523814"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.8.8"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.BSplineKit]]
deps = ["ArrayLayouts", "BandedMatrices", "FastGaussQuadrature", "Interpolations", "LazyArrays", "LinearAlgebra", "Random", "Reexport", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "651e79138b30580c5a1586b67c3298be6c7b8afe"
uuid = "093aae92-e908-43d7-9660-e50ee39d5a0a"
version = "0.8.4"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "019aa88766e2493c59cbd0a9955e1bac683ffbcd"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.16.13"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "b15a6bc52594f5e4a3b825858d1089618871bf9d"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.36"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "873fb188a4b9d76549b81465b1f75c82aaf59238"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.4"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "5f5a975d996026a8dd877c35fe26a7b8179c02ba"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.6"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "2dd813e5f2f7eec2d1268c57cf2373d3ee91fcea"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.1"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonSolve]]
git-tree-sha1 = "332a332c97c7071600984b3c31d9067e1a4e6e25"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.1"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "9be8be1d8a6f44b96482c8af52238ea7987da3e3"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.45.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[deps.CondaPkg]]
deps = ["JSON3", "Markdown", "MicroMamba", "Pkg", "TOML"]
git-tree-sha1 = "05b87006388d954cc0b0e0164361b04f6f275e7d"
uuid = "992eb4ea-22a4-4c89-a5bb-47a3300528ab"
version = "0.2.11"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "59d00b3139a9de4eb961057eabb65ac6522be954"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "daa21eb85147f72e41f6352a57fccea377e310a9"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.0.0"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "429077fd74119f5ac495857fd51f4120baf36355"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.65"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

[[deps.FastGaussQuadrature]]
deps = ["LinearAlgebra", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "58d83dd5a78a36205bdfddb82b1bb67682e64487"
uuid = "442a2c76-b920-505d-bb47-c5924d526838"
version = "0.4.9"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "129b104185df66e408edd6625d480b7f9e9823a0"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.18"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDiff]]
deps = ["ArrayInterfaceCore", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "e3af8444c9916abed11f4357c2f59b6801e5b376"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.13.1"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "2f18915445b248731ec5db4e4a17e451020bf21e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.30"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "cabd77ab6a6fdff49bfd24af2ebe76e6e018a2b4"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.0.0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "b5c7fe9cea653443736d264b85466bad8c574f4a"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.9.9"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "cb7099a0109939f16a4d3b572ba8396b1f6c7c31"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.10"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "d19f9edd8c34760dca2de2b503f969d8700ed288"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b7bc05649af456efc75d178846f47006c2c4c3c7"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.6"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "fd6f0cae36f42525567108a42c1c674af2ac620d"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.5"

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "MatrixFactorizations", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "d9a962fac652cc6b0224622b18199f0ed46d316a"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "0.22.11"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.83.1+1"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.LifeContingencies]]
deps = ["ActuaryUtilities", "Dates", "MortalityTables", "Transducers", "Yields"]
git-tree-sha1 = "8f297d7a606ff83d6352f21e614cbb0a815acd17"
uuid = "c8f0d631-89cd-4a1f-93d0-7542c3692561"
version = "2.2.0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LsqFit]]
deps = ["Distributions", "ForwardDiff", "LinearAlgebra", "NLSolversBase", "OptimBase", "Random", "StatsBase"]
git-tree-sha1 = "91aa1442e63a77f101aff01dec5a821a17f43922"
uuid = "2fda8390-95c7-5789-9bda-21331edee243"
version = "0.12.1"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MarchingCubes]]
deps = ["StaticArrays"]
git-tree-sha1 = "3bf4baa9df7d1367168ebf60ed02b0379ea91099"
uuid = "299715c1-40a9-479a-aaf9-4a633d36f717"
version = "0.1.3"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MatrixFactorizations]]
deps = ["ArrayLayouts", "LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "2212d36f97e01347adb1460a6914e20f2feee853"
uuid = "a3b82374-2e81-5b9e-98ce-41277c0e4c87"
version = "0.9.1"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "6bb7786e4f24d44b4e29df03c69add1b63d88f01"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.2"

[[deps.MicroMamba]]
deps = ["Pkg", "Scratch"]
git-tree-sha1 = "18ae2d81035c717f9b0d92c809575266dfe73cc9"
uuid = "0b3b1443-0f03-428d-bdfb-f27f9c1191ea"
version = "0.1.8"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

[[deps.MortalityTables]]
deps = ["Memoize", "OffsetArrays", "Parsers", "Pkg", "QuadGK", "Requires", "StringDistances", "UnPack", "XMLDict"]
git-tree-sha1 = "8ae1af8a53147c592a95fbce9fd37dda2a50355f"
uuid = "4780e19d-04b9-53dc-86c2-9e9aa59b5a12"
version = "2.3.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "1ea784113a6aa054c5ebd95945fa5e52c2f378e7"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.7"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7a28efc8e34d5df89fc87343318b0a8add2c4021"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.0"

[[deps.OptimBase]]
deps = ["NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "9cb1fee807b599b5f803809e85c81b582d2009d6"
uuid = "87e2bd06-a317-5318-96d9-3ecbac512eee"
version = "2.0.2"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PythonCall]]
deps = ["CondaPkg", "Dates", "Libdl", "MacroTools", "Markdown", "Pkg", "Requires", "Serialization", "Tables", "UnsafePointers"]
git-tree-sha1 = "3f636cbf5646308b972add08b127dc931954971b"
uuid = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
version = "0.9.3"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.RData]]
deps = ["CategoricalArrays", "CodecZlib", "DataFrames", "Dates", "FileIO", "Requires", "TimeZones", "Unicode"]
git-tree-sha1 = "19e47a495dfb7240eb44dc6971d660f7e4244a72"
uuid = "df47a6cb-8c03-5eed-afd8-b6050d6c41da"
version = "0.8.3"

[[deps.RDatasets]]
deps = ["CSV", "CodecZlib", "DataFrames", "FileIO", "Printf", "RData", "Reexport"]
git-tree-sha1 = "2720e6f6afb3e562ccb70a6b62f8f308ff810333"
uuid = "ce6b1742-4840-55fa-b093-852dadbb1d8b"
version = "0.7.7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "838b60ee62bebc794864c880a47e331e00c47505"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.4.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "db8481cf5d6278a121184809e9eb1628943c7704"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.13"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["DelimitedFiles", "Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "39c9f91521de844bad65049efd4f9223e7ed43f9"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.14"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "9f8a5dc5944dc7fbbe6eb4180660935653b0a9d9"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.0"

[[deps.StaticArraysCore]]
git-tree-sha1 = "66fe9eb253f910fe8cf161953880cfdaef01cdf0"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.0.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2c11d7290036fe7aac9038ff312d3b3a2a5bf89e"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.4.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "48598584bacbebf7d30e20880438ed1d24b7c7d6"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.18"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[deps.StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "ceeef74797d961aee825aabf71446d6aba898acb"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.2"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "ec47fb6069c57f1cee2f67541bf8f23415146de7"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.11"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "0a4d8838dc28b4bcfaa3a20efb8d63975ad6781d"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.8.0"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "c76399a3bbe6f5a88faa33c8f8a65aa631d95013"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.73"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodePlots]]
deps = ["ColorTypes", "Contour", "Crayons", "Dates", "FileIO", "FreeTypeAbstraction", "LazyModules", "LinearAlgebra", "MarchingCubes", "NaNMath", "Printf", "SparseArrays", "StaticArrays", "StatsBase", "Unitful"]
git-tree-sha1 = "ae67ab0505b9453655f7d5ea65183a1cd1b3cfa0"
uuid = "b8865327-cd53-5732-bb35-84acbb429228"
version = "2.12.4"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "b649200e887a487468b71821e2644382699f1b0f"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.11.0"

[[deps.UnsafePointers]]
git-tree-sha1 = "c81331b3b2e60a982be57c046ec91f599ede674a"
uuid = "e17b2a0c-0bdf-430a-bd0c-3a23cae4ff39"
version = "1.0.0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XMLDict]]
deps = ["EzXML", "IterTools", "OrderedCollections"]
git-tree-sha1 = "d9a3faf078210e477b291c79117676fca54da9dd"
uuid = "228000da-037f-5747-90a9-8195ccbf91a5"
version = "0.4.1"

[[deps.Yields]]
deps = ["BSplineKit", "ForwardDiff", "LinearAlgebra", "LsqFit", "Optim", "Roots", "UnicodePlots"]
git-tree-sha1 = "af92587ae93b8a7f2c0bdc3626e41ca6332675c1"
uuid = "d7e99b2f-e7f3-4d9e-9f01-2338fc023ad3"
version = "3.1.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.47.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─3c2da572-90d0-4206-9586-18f2cea6b6ca
# ╟─458f2690-e3fb-40a8-a657-e3a0666af69c
# ╟─142954b2-9615-4527-9a1a-d687583ff38e
# ╟─0c351b21-f3ee-43ee-8cb0-fb0faf003c84
# ╟─47c7ecd8-1610-4ce8-bff1-814a48336368
# ╠═7b86f12b-de88-40e0-bee3-1d9ba188fd40
# ╟─a1ea0a4f-8074-4a3f-a88b-eb9f4e8ece3d
# ╟─baee42c3-b745-4657-8904-56e3f69c66ca
# ╠═4b92b938-b5e1-4389-9a94-f8ded9d8c4d9
# ╠═9a237e79-80ec-4dce-a3f4-4856ae8dcd5b
# ╟─93647fd4-e466-48d1-b2e4-eb47d3e0f813
# ╟─721d4318-071b-4ff2-a29f-a005b4ff2ffc
# ╠═009b8e21-a7a2-41d0-af6c-5be89ea819f7
# ╠═3691567a-9d96-4fcf-a02a-30b716944a90
# ╠═1d6c8644-fe0e-48c7-8bf0-e69ce366922a
# ╟─fb686b8b-bbb8-43b5-8241-493463275346
# ╠═f23b4b4e-baf5-4a7d-9a33-14050f1993e6
# ╟─5c811d55-53df-4a9c-b75f-4656168b70e2
# ╟─48ac1891-9047-47bf-9536-ec841c746907
# ╟─0fa9947b-0d09-416f-869e-4b62861cdcc7
# ╠═e8696f90-3295-4054-89ca-9ef21595d036
# ╟─80b2e45b-e024-4b3b-9d6d-bf67ba0bddfb
# ╠═e26e3daf-ee55-434d-9d46-c083537df72a
# ╟─47556a7c-230a-4211-af06-f6fb61fbd7c1
# ╠═ae5ed9ec-c4a3-4765-a3e2-35e9e2a285f1
# ╟─6e4662da-72a5-42a5-80c5-a5846513a1ff
# ╟─8855b283-153e-4b9c-9758-97e0dea133a4
# ╟─37e2e205-0c7e-4135-9e25-901d03fe38a1
# ╠═4daea69e-a4b5-48f6-b932-b90a38544105
# ╠═519a702a-0dfd-4ecd-a66e-58a5bac0d97b
# ╟─adcc763b-b35d-4e3d-af26-dcbe3e648830
# ╠═6124bd7b-b49e-42c8-9957-5425d78420a8
# ╟─c414d316-454e-4a0c-aeac-54826cc6b203
# ╟─b77156a3-1180-434e-90ec-841b8ef8d632
# ╟─ae022006-fd36-45c0-a68b-a754505db1f0
# ╟─e4266932-a4c6-4345-ae62-e18a0561dcb2
# ╟─7beb3fff-6845-4f60-85cf-aa8b74e0664e
# ╟─c2411811-0d9f-4ebc-b6d8-b81280d6060d
# ╠═1b9285cc-1ef5-495d-ab14-5515509f8d21
# ╠═a2eedbb6-679a-4796-b226-bf7f62d7d38e
# ╠═eeaeae8f-f4ec-489e-bc41-a46cddd1f0b1
# ╠═a9961f0d-080b-40d3-b59b-2f687ce9b833
# ╠═62c5eec4-f540-4884-9612-05c5b5e826d9
# ╠═81070c4e-1d96-41c2-b4db-c9938633fe7f
# ╠═f4fbccda-286d-42cb-93e7-93654b8d7892
# ╠═63a43efc-751a-49f2-8ff3-e47c44e2d627
# ╠═6cdbbece-0b44-4931-b167-801c698ab2c3
# ╠═18517698-7727-42f9-a378-02955793c422
# ╠═d6d07e01-7966-412c-a2c1-61e05955f8bd
# ╟─ca14f376-b2d7-411f-9702-d496390eb45e
# ╠═d49c5675-42d1-4ccf-a0df-4eb49bc9de0f
# ╟─e94fc916-27a9-448d-9237-65a8e954e2af
# ╟─be39b864-45cb-480d-9bb2-67d56a495147
# ╠═1c0ccd93-59b8-46e2-bf3a-45ae79b35af0
# ╟─af9484e7-7f5c-448e-9b49-a2a9adbcc596
# ╠═f506bcbe-4d67-4e61-8b2f-af23b0ddf1cd
# ╠═b3238c9a-a7bc-4dbe-9657-fc23144a400c
# ╠═969ecaae-c39c-46e6-b7b8-0c6fd910339b
# ╠═119b6051-c1f3-41e5-a415-4358d1366703
# ╟─e92df94f-cb38-486f-89be-5b8a39aa59c9
# ╟─a0af8bfc-357c-452f-9b0f-4b6bef4c2714
# ╠═663067a1-704d-4a1a-bf26-1bccb160bc67
# ╟─4a906be4-9c1e-459e-84e0-394601c57a00
# ╠═0d387f41-24a5-4233-b229-15ada348a20a
# ╠═d84db7cb-49e1-4cba-9b9d-b593b0151aeb
# ╠═3253db45-ebd8-4047-8182-45fe5a1305e4
# ╟─7238532c-f2b0-4b63-b028-109caf2c196b
# ╠═9675af2c-f6e1-4fbb-8b85-221226d0bd2b
# ╟─0165537c-7735-4a07-859a-a09a43f4b494
# ╠═5332aae1-11ff-42f4-adbf-b131a8b238bc
# ╠═5b690c88-7cb6-4618-9980-933789bf51c2
# ╠═b20695b9-b1c3-44c6-9e7e-8927ba007fae
# ╠═c2f6787b-e7d4-4c7e-ab31-f5cad6e75929
# ╠═a645d95a-ebb1-4d48-83c0-830faa754f31
# ╠═e40482d8-0a49-4681-aa3f-8c04e1f80c96
# ╠═f5c0f9bc-1032-4ab8-b7bd-8149e8d77118
# ╠═c96d27e5-fe7a-46a4-944c-38b767e1b885
# ╟─a132b7ea-dbe4-4869-b6a0-417b49517234
# ╠═a74b7bd9-7869-44a4-b51d-fe400ba70e89
# ╠═3582a3c0-c156-4c60-b622-760dd55f552b
# ╟─de6303ac-8da9-4848-ad7e-714ca2c894bb
# ╠═5405b11b-288e-4e06-917c-1eb6a82a1ac9
# ╠═00567c83-29fc-47a8-911a-a28e77ded7b2
# ╠═94264fcb-b69f-4f9b-b8bb-83c31e22ffb1
# ╠═4cb7f1e1-8a07-4bd3-b92e-1a6c0ff3698f
# ╠═d73421f8-e2e9-4b9a-90af-d7625a1d30c5
# ╠═0bfc0522-10a1-4d08-a8fb-5c0dcbe1db77
# ╠═c7da89f1-33f2-44e9-aa30-49f7da89632d
# ╠═6d405814-7f56-4534-abc8-262a7f5a1750
# ╠═3b3c4951-7c85-41b1-9f5b-1a23f4b4c465
# ╠═f1675cb1-ece0-4a5f-a0eb-7fd16010461c
# ╠═8320edcc-ef78-11ec-0445-b100a477c027
# ╠═1e3e432b-3027-4dfe-992c-14189f675181
# ╠═e536d967-ba2f-4a06-b159-a652e22d30af
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
