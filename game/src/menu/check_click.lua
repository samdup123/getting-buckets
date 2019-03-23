return function(area, click)
    print(click.x, click.y, area.x, area.y, area.width, area.height)
    return click.x >= area.x and click.x <= (area.x + area.width) and click.y >= area.y and click.y <= (area.y + area.height)
end
