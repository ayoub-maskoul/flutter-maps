<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    
    public function register(Request $request) {
        $valid = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email',
            'password' => 'required|min:5|confirmed',
        ]);

        $user= User::create([
            'name' => $valid['name'],
            'email' => $valid['email'],
            'password' => bcrypt($valid['password']),
        ]);

        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ]);
    }

    public function login(Request $request) {
        
        $valid = $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:5',
        ]);

        if (!Auth::attempt($valid)) {
            return response([
                'message' => 'Invalid Login'
            ],403);
        }
    
        $user = Auth::user();
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ],200);
    }

    public function logout(){
        
        $user = Auth::user();
        $user->tokens()->delete();
        return response([
            'message' => 'Logout success'
        ],200);
    }
    public function user(){
        
        $user = Auth::user();
        return response([
            'user' => $user
        ],200);
    }

}
