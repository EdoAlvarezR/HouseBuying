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

# ╔═╡ 1038fa17-359e-4ed0-9017-e6dff94e0b47
begin	
	# Activate environment
    import Pkg
    Pkg.activate(".")

	# Registered packages
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("LaTeXStrings")
	Pkg.add("CSV")
	Pkg.add("DataFrames")
	# Pkg.add("ForwardDiff")
	# Pkg.add("FLOWMath")
	# Pkg.add("SNOW")

	# Import packages
	import Plots
	using PlutoUI
	import LaTeXStrings: @L_str
	import CSV
	import DataFrames: DataFrame
	# import ForwardDiff as FD
	# import FLOWMath
	# import SNOW

	md"""
	## Importing Packages
	"""
end

# ╔═╡ 72de331c-e4a4-11ed-1257-6b98f8b61f0d
html"""
<center>
    <span style="font-size: 1.0em; color:black"><b>
        Calculator
    </b></span>
    <br>
    <span style="font-size: 2.8em; color:black"><b>
        Amortization Schedule
    </b></span>
    <br>
    <span style="font-size: 0.75em;"><i>
        The content of this notebook is intellectual property of <a href="https://edoalvarez.com">Eduardo J. Alvarez</a>. <br>
        No use or sharing of this information is allowed without written consent.
    </i></span> 
</center>
"""

# ╔═╡ a28190ea-0665-411b-903a-d768c00ded3b
md"""
## Schedule
"""

# ╔═╡ 73f5448d-3156-43e2-9aa7-2b0aa61915f9
begin
	b = @bind reveal html"<input type=checkbox>"
	md"""
	## Backend
	Reveal hidden cells: $(b)
	"""
end

# ╔═╡ 169b9b8c-5992-43fe-bad6-319abfeff3fe
begin
	# Colors
	clru = "#003d6d"
	clrl = "darkred"
	clrt = "black"
	clr0 = "gray"
	clropt = "cyan"

	# Styles
	stlt = :solid
	stl0 = :dash
	stlopt = :solid

	"""
		Calculates the principal+interest monthly payment for an initial
		loan `P0`, monthly interest rate `ir` (fraction), and `N` months
	"""
	function calc_monthypayment(P0, ir, N)
		M = P0 * ir * (1+ir)^N / ( (1+ir)^N - 1 )
	end

	"""
		Calculates the amortization at a given month with an initial principal
		`P`, monthly interest rate `ir` (fraction), and monthly payment `M`.
		See https://www.ramseysolutions.com/real-estate/amortization-schedule.

		Returns: (principal payment, interest payment)
	"""
	function calc_amortization(P, ir, M)
		b = P*ir
		a = M - b
		return a, b
	end
	
	md"""
	## Analysis Functions
	"""
end

# ╔═╡ 28671bc7-b6a3-4665-9be2-5354396a97ea
begin
	loanamount_select = 
		@bind P0 NumberField(50000:5000:600000, default=240000)
	program_select = 
		@bind Y NumberField(1:50, default=15)
	APR_select = 
		@bind APR NumberField(3:0.01:8, default=6.0)

	N = ceil(Int, Y*12)	              # Number of months
	ir = APR/12/100                   # Monthly interest rate (as fraction)
	M = calc_monthypayment(P0, ir, N) # Monthly payment

	totalbyend = M*N                  # Total amount paid by end of loan
		
	md"""	
	| **Loan Terms**  | | | | 
	|---------: | :---------- | ----------: | :---------- |
	| Loan amount $P_0$: | $(loanamount_select) | Monthly payment $M$: | \$$(Int(round(M))) |
	| Program: | $(program_select)-year fixed | Paid by end | \$$(Int(round(totalbyend))) |
	| Interest: | $(APR_select)% (APR)| Total interest | \$$(Int(round(totalbyend - P0))) |

	*Monthly payment $M$ includes only principal and interest* 
	"""
end

# ╔═╡ c407b966-88fa-49f4-90bb-75e03ab8dc31
begin
	payments = [M for n in 1:N]         # Payment for each month
	
	# Compute amortization schedule
	principal, interest, balance, interesttot = (zeros(N+1) for i in 1:4)
	
	balance[1] = P0                     # Initial condition
	
	for n in 1:N
		a, b = calc_amortization(balance[n], ir, payments[n])
	
		principal[n+1] = a
		interest[n+1] = b
		balance[n+1] = balance[n] - a
		interesttot[n+1] = interesttot[n] + b
	end

	principal = Int.(round.(principal))
	interest = Int.(round.(interest))
	balance = Int.(round.(balance))
	interesttot = Int.(round.(interesttot))
	payment = vcat(0, Int.(round.(payments)))
	
	amortizationschedule = DataFrame(; payment, principal, interest, interesttot, balance)
end

# ╔═╡ ad43d379-c720-47a4-8bca-233ededa875b
begin
	endyear_select = 
		@bind Yend Slider(0:0.5:Y, show_value=true, default=4.5)

	Nend = ceil(Int, Yend*12)
	
	resend = DataFrame(; 
				endyear=round(Nend/12, digits=1),
				paymenttot=sum(payment[1:(Nend+1)]), 
				interesttot=interesttot[Nend+1], 
				balance=balance[Nend+1]
			)
		
	md"""	
	| **Selling Point**  | | | | 
	|---------: | :---------- | ----------: | :---------- |
	| When to sell: | $(endyear_select) years| | |

	$(resend)
	"""
end

# ╔═╡ 9761d934-37ea-4481-9fe6-488409dcd4dc
begin	
	println(Nend)
end

# ╔═╡ 7ba9cb51-0e85-419f-acd0-21ad673c7c41
begin
	hide_everything_below =
		html"""
		<style>
		pluto-cell.hide_everything_below ~ pluto-cell {
			display: none;
		}
		</style>
		
		<script>
		const cell = currentScript.closest("pluto-cell")
		
		const setclass = () => {
			console.log("change!")
			cell.classList.toggle("hide_everything_below", true)
		}
		setclass()
		const observer = new MutationObserver(setclass)
		
		observer.observe(cell, {
			subtree: false,
			attributeFilter: ["class"],
		})
		
		invalidation.then(() => {
			observer.disconnect()
			cell.classList.toggle("hide_everything_below", false)
		})
		
		</script>
		""";
	
	md"""
	## Hide Function
	"""
end

# ╔═╡ d4fff2e2-2f0f-480c-b025-f75b43fb2a39
if reveal === true
	md"As you wish!"
else
	hide_everything_below
end

# ╔═╡ 926ef9ca-547a-4c76-ae74-bfe7799e5614
space = html"<br><br><br>";

# ╔═╡ Cell order:
# ╟─72de331c-e4a4-11ed-1257-6b98f8b61f0d
# ╟─28671bc7-b6a3-4665-9be2-5354396a97ea
# ╟─a28190ea-0665-411b-903a-d768c00ded3b
# ╟─c407b966-88fa-49f4-90bb-75e03ab8dc31
# ╟─ad43d379-c720-47a4-8bca-233ededa875b
# ╠═9761d934-37ea-4481-9fe6-488409dcd4dc
# ╟─73f5448d-3156-43e2-9aa7-2b0aa61915f9
# ╟─d4fff2e2-2f0f-480c-b025-f75b43fb2a39
# ╠═169b9b8c-5992-43fe-bad6-319abfeff3fe
# ╠═1038fa17-359e-4ed0-9017-e6dff94e0b47
# ╠═7ba9cb51-0e85-419f-acd0-21ad673c7c41
# ╟─926ef9ca-547a-4c76-ae74-bfe7799e5614
