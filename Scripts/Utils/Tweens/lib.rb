
# Copyright (c) 2013 Damián Silvani

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# https://github.com/munshkr/easing-ruby

  # Added function
  def easing(t,b,c,d,e)

  	t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

  	case e
  		when :linear; linear_tween(t,b,c,d)

  		when :quad_in, :quad_i, :qi; ease_in_quad(t,b,c,d)
  		when :quad_out, :quad_o, :qo; ease_out_quad(t,b,c,d)
  		when :quad_in_out, :quad_io, :qio; ease_in_out_quad(t,b,c,d)

  		when :cubic_in, :cubic_i; ease_in_cubic(t,b,c,d)
  		when :cubic_out, :cubic_o; ease_out_cubic(t,b,c,d)
  		when :cubic_in_out, :cubic_io; ease_in_out_cubic(t,b,c,d)

  		when :quart_in, :quart_i; ease_in_quart(t,b,c,d)
  		when :quart_out, :quart_o; ease_out_quart(t,b,c,d)
  		when :quart_in_out, :quart_io; ease_in_out_quart(t,b,c,d)

  		when :quint_in, :quint_i; ease_in_quint(t,b,c,d)
  		when :quint_out, :quint_i; ease_out_quint(t,b,c,d)
  		when :quint_in_out, :quint_io; ease_in_out_quint(t,b,c,d)

  		when :sine_in, :sine_i; ease_in_sine(t,b,c,d)
  		when :sine_out, :sine_o; ease_out_sine(t,b,c,d)
  		when :sine_in_out, :sine_io; ease_in_out_sine(t,b,c,d)

  		when :expo_in, :expo_i; ease_in_expo(t,b,c,d)
  		when :expo_out, :expo_o; ease_out_expo(t,b,c,d)
  		when :expo_in_out, :expo_io; ease_in_out_expo(t,b,c,d)

  		when :circ_in, :circ_i; ease_in_circ(t,b,c,d)
  		when :circ_out, :circ_o; ease_out_circ(t,b,c,d)
  		when :circ_in_out, :circ_io; ease_in_out_circ(t,b,c,d)

      when :bounce_in, :bounce_i; ease_in_bounce(t,b,c,d)
      when :bounce_out, :bounce_o; ease_out_bounce(t,b,c,d)
      when :bounce_in_out, :bounce_io; ease_in_out_bounce(t,b,c,d)

  	end

  end

  def linear_tween(t, b, c, d)
    c * t / d + b
  end

  def ease_in_quad(t, b, c, d)
    return c*(t/=d)*t + b;
  end

  def ease_out_quad(t, b, c, d)
    return -c *(t/=d)*(t-2) + b;
  end

  def ease_in_out_quad(t, b, c, d)
    t /= d / 2
    return c / 2*t*t + b if (t < 1)
    t -= 1
    return -c/2 * (t*(t-2) - 1) + b
  end

  def ease_in_cubic(t, b, c, d)
    return c*(t/=d)*t*t + b
  end

  def ease_out_cubic(t, b, c, d)
    return c*((t=t/d-1)*t*t + 1) + b
  end

  def ease_in_out_cubic(t, b, c, d)
    return c/2*t*t*t + b if ((t/=d/2) < 1)
    return c/2*((t-=2)*t*t + 2) + b
  end

  def ease_in_quart(t, b, c, d)
    return c*(t/=d)*t*t*t + b
  end

  def ease_out_quart(t, b, c, d)
    return -c * ((t=t/d-1)*t*t*t - 1) + b
  end

  def ease_in_out_quart(t, b, c, d)
    return c/2*t*t*t*t + b if ((t/=d/2) < 1)
    return -c/2 * ((t-=2)*t*t*t - 2) + b
  end

  def ease_in_quint(t, b, c, d)
    return c*(t/=d)*t*t*t*t + b
  end

  def ease_out_quint(t, b, c, d)
    return c*((t=t/d-1)*t*t*t*t + 1) + b
  end

  def ease_in_out_quint(t, b, c, d)
    return c/2*t*t*t*t*t + b if ((t/=d/2) < 1)
    return c/2*((t-=2)*t*t*t*t + 2) + b
  end

  def ease_in_sine(t, b, c, d)
    return -c * Math.cos(t/d * (Math::PI/2)) + c + b
  end

  def ease_out_sine(t, b, c, d)
    return c * Math.sin(t/d * (Math::PI/2)) + b
  end

  def ease_in_out_sine(t, b, c, d)
    return -c/2 * (Math.cos(Math::PI*t/d) - 1) + b
  end

  def ease_in_expo(t, b, c, d)
    return (t==0) ? b : c * (2 ** (10 * (t/d - 1))) + b
  end

  def ease_out_expo(t, b, c, d)
    return (t==d) ? b+c : c * (-2**(-10 * t/d) + 1) + b
  end

  def ease_in_out_expo(t, b, c, d)
    return b if t == 0
    return b + c if t == d
    return (c/2) * 2**(10 * (t-1)) + b if ((t /= d/2) < 1)
    return (c/2) * (-2**(-10 * t-=1) + 2) + b
  end

  def ease_in_circ(t, b, c, d)
    return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b
  end

  def ease_out_circ(t, b, c, d)
    return c * Math.sqrt(1 - (t=t/d-1)*t) + b
  end

  def ease_in_out_circ(t, b, c, d)
    return -c/2 * (Math.sqrt(1 - t*t) - 1) + b if ((t/=d/2) < 1)
    return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b
  end

  # Added
  def ease_in_bounce(t,b,c,d)
  	return c - ease_out_bounce(d-t,0,c,d) + b
  end

  def ease_out_bounce(t,b,c,d)
  	t /= d
  	if ( (t) < (1 / 2.75))
  		return c * (7.5625 * t * t) + b
  	elsif (t < (2 / 2.75))
  		t -= (1.5 / 2.75)
  		return c * (7.5625 * (t) * t + 0.75) + b
  	elsif (t < (2.5 / 2.75))
  		t -= (2.25 / 2.75)
  		return c * (7.5625 * (t) * t + 0.9375) + b
  	else
  		t -= (2.625 / 2.75)
  		return c * (7.5625 * (t) * t + 0.984375) + b
  	end
  end

  def ease_in_out_bounce(t,b,c,d)
  	if (t < d / 2)
  		return ease_in_bounce(t * 2, 0, c, d) * 0.5 + b;
  	else
  		return ease_out_bounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
  	end
  end