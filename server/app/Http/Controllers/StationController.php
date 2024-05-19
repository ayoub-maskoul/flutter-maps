<?php

namespace App\Http\Controllers;

use App\Models\Station;
use Illuminate\Http\Request;

class StationController extends Controller
{
    public function index(Request $request)
    {
        $station = Station::query();
        if($request->has('city')){
            $city=$request->city;
            $station->where('city', 'LIKE', "%$city%");
        };
        
        return response()->json([
            'status' => true,
            'station' => $station->get()
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $station = Station::create($request->all());

        return response()->json([
            'status' => true,
            'message' => "Station Created successfully!",
            'station' => $station
        ], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $station=Station::find($id);
        if ($station) {
            return response()->json([
                    
                'status' => true,
                'station' => $station,
            ]);
        }

    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,int $id)
    {
        $station=Station::find($id);

        $station->update($request->all());

        return response()->json([
            'status' => true,
            'message' => "station Update successfully!",
            'station' => $station
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(int $id)
    {
        $station=Station::find($id);
        if ($station) {
                $station->delete();
            return response()->json([
                    
                'status' => true,
                'message' => "station delete successfully!",
            ]);
        }
    }
}
